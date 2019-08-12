###
# Copyright (C) 2014-2018 Tuesmon Agile LLC
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#
# File: modules/controllerMixins.coffee
###

tuesmon = @.tuesmon

groupBy = @.tuesmon.groupBy
joinStr = @.tuesmon.joinStr
trim = @.tuesmon.trim
toString = @.tuesmon.toString


#############################################################################
## Page Mixin
#############################################################################

class PageMixin
    fillUsersAndRoles: (users, roles) ->
        activeUsers = _.filter(users, (user) => user.is_active)
        @scope.activeUsers = _.sortBy(activeUsers, "full_name_display")
        @scope.activeUsersById = groupBy(@scope.activeUsers, (e) -> e.id)

        @scope.users = _.sortBy(users, "full_name_display")
        @scope.usersById = groupBy(users, (e) -> e.id)

        @scope.roles = _.sortBy(roles, "order")
        computableRoles = _(@scope.project.members).map("role").uniq().value()
        @scope.computableRoles = _(roles).filter("computable")
                                         .filter((x) -> _.includes(computableRoles, x.id))
                                         .value()
    loadUsersAndRoles: ->
        promise = @q.all([
            @rs.projects.usersList(@scope.projectId),
            @rs.projects.rolesList(@scope.projectId)
        ])

        return promise.then (results) =>
            [users, roles] = results
            @.fillUsersAndRoles(users, roles)
            return results

tuesmon.PageMixin = PageMixin


#############################################################################
## Filters Mixin
#############################################################################
# This mixin requires @location ($tgLocation), and @scope

class FiltersMixin
    excludePrefix: "exclude_"

    selectFilter: (name, value, load=false, mode="include") ->
        params = @location.search()

        if mode == "exclude"
            name = @.excludePrefix.concat(name)

        if params[name] != undefined and name != "page"
            existing = _.map(tuesmon.toString(params[name]).split(","), (x) -> trim(x))
            existing.push(tuesmon.toString(value))
            existing = _.compact(existing)
            value = joinStr(",", _.uniq(existing))

        if !@location.isInCurrentRouteParams(name, value)
            location = if load then @location else @location.noreload(@scope)
            location.search(name, value)

    replaceFilter: (name, value, load=false) ->
        if !@location.isInCurrentRouteParams(name, value)
            location = if load then @location else @location.noreload(@scope)
            location.search(name, value)

    replaceAllFilters: (filters, load=false) ->
        location = if load then @location else @location.noreload(@scope)
        location.search(filters)

    unselectFilter: (name, value, load=false, mode='include') ->
        params = @location.search()

        if mode == "exclude"
            name = @.excludePrefix.concat(name)

        if params[name] is undefined
            return

        if value is undefined or value is null
            delete params[name]

        parsedValues = _.map(tuesmon.toString(params[name]).split(","), (x) -> trim(x))
        newValues = _.reject(parsedValues, (x) -> x == tuesmon.toString(value))
        newValues = _.compact(newValues)

        if _.isEmpty(newValues)
            value = null
        else
            value = joinStr(",", _.uniq(newValues))

        location = if load then @location else @location.noreload(@scope)
        location.search(name, value)

    applyStoredFilters: (projectSlug, key) ->
        if _.isEmpty(@location.search())
            filters = @.getFilters(projectSlug, key)
            if Object.keys(filters).length
                @location.search(filters)
                @location.replace()

                return true

        return false

    storeFilters: (projectSlug, params, filtersHashSuffix) ->
        ns = "#{projectSlug}:#{filtersHashSuffix}"
        hash = tuesmon.generateHash([projectSlug, ns])
        @storage.set(hash, params)

    getFilters: (projectSlug, filtersHashSuffix) ->
        ns = "#{projectSlug}:#{filtersHashSuffix}"
        hash = tuesmon.generateHash([projectSlug, ns])

        return @storage.get(hash) or {}

    formatSelectedFilters: (type, list, urlIds, mode="include") ->
        selectedIds = urlIds.split(',')
        selectedFilters = _.filter list, (it) ->
            selectedIds.indexOf(_.toString(it.id)) != -1

        invalidTags = _.filter selectedIds, (it) ->
            return !_.find selectedFilters, (sit) -> _.toString(sit.id) == it

        invalidAppliedTags =  _.map invalidTags, (it) ->
            return {
                id: it
                key: type + ":" + it
                dataType: type,
                name: it
                mode: mode
            }

        validAppliedTags = _.map selectedFilters, (it) ->
            return {
                id: it.id
                key: type + ":" + it.id
                dataType: type,
                name: it.name
                color: it.color
                mode: mode
            }

        return invalidAppliedTags.concat(validAppliedTags)

tuesmon.FiltersMixin = FiltersMixin

#############################################################################
## Us Filters Mixin
#############################################################################

class UsFiltersMixin
    excludePrefix: "exclude_"
    filterCategories: [
        "tags",
        "status",
        "assigned_users",
        "assigned_to",
        "owner",
        "epic",
        "role",
    ]

    changeQ: (q) ->
        @.replaceFilter("q", q)
        @.filtersReloadContent()
        @.generateFilters()

    removeFilter: (filter) ->
        @.unselectFilter(filter.dataType, filter.id, false, filter.mode)
        @.filtersReloadContent()
        @.generateFilters()

    addFilter: (newFilter) ->
        @.selectFilter(newFilter.category.dataType, newFilter.filter.id, false, newFilter.mode)
        @.filtersReloadContent()
        @.generateFilters()

    selectCustomFilter: (customFilter) ->
        @.replaceAllFilters(customFilter.filter)
        @.filtersReloadContent()
        @.generateFilters()

    saveCustomFilter: (name) ->
        filters = {}
        urlfilters = @location.search()

        for key in @.filterCategories
            excludeKey = @.excludePrefix.concat(key)
            filters[key] = urlfilters[key]
            filters[excludeKey] = urlfilters[excludeKey]

        @filterRemoteStorageService.getFilters(@scope.projectId, @.storeCustomFiltersName).then (userFilters) =>
            userFilters[name] = filters

            @filterRemoteStorageService.storeFilters(@scope.projectId, userFilters, @.storeCustomFiltersName).then(@.generateFilters)

    removeCustomFilter: (customFilter) ->
        @filterRemoteStorageService.getFilters(@scope.projectId, @.storeCustomFiltersName).then (userFilters) =>
            delete userFilters[customFilter.id]

            @filterRemoteStorageService.storeFilters(@scope.projectId, userFilters, @.storeCustomFiltersName).then(@.generateFilters)
            @.generateFilters()

    isFilterDataTypeSelected: (filterDataType) ->
        for filter in @.selectedFilters
            if (filter['dataType'] == filterDataType)
                return true
        return false

    generateFilters: (milestone) ->
        @.storeFilters(@params.pslug, @location.search(), @.storeFiltersName)

        urlfilters = @location.search()

        loadFilters = {}
        loadFilters.project = @scope.projectId
        loadFilters.q = urlfilters.q

        for key in @.filterCategories
            excludeKey = @.excludePrefix.concat(key)
            loadFilters[key] = urlfilters[key]
            loadFilters[excludeKey] = urlfilters[excludeKey]

        if milestone
            loadFilters.milestone = milestone

        return @q.all([
            @rs.userstories.filtersData(loadFilters),
            @filterRemoteStorageService.getFilters(@scope.projectId, @.storeCustomFiltersName)
        ]).then (result) =>
            data = result[0]
            customFiltersRaw = result[1]
            dataCollection = {}

            dataCollection.status = _.map data.statuses, (it) ->
                it.id = it.id.toString()

                return it
            dataCollection.tags = _.map data.tags, (it) ->
                it.id = it.name

                return it
            tagsWithAtLeastOneElement = _.filter dataCollection.tags, (tag) ->
                return tag.count > 0
            dataCollection.assigned_users = _.map data.assigned_users, (it) ->
                if it.id
                    it.id = it.id.toString()
                else
                    it.id = "null"

                it.name = it.full_name || "Unassigned"

                return it
            dataCollection.assigned_to = _.map data.assigned_to, (it) ->
                if it.id
                    it.id = it.id.toString()
                else
                    it.id = "null"

                it.name = it.full_name || "Unassigned"

                return it
            dataCollection.role = _.map data.roles, (it) ->
                if it.id
                    it.id = it.id.toString()
                else
                    it.id = "null"

                it.name = it.name || "Unassigned"

                return it
            dataCollection.owner = _.map data.owners, (it) ->
                it.id = it.id.toString()
                it.name = it.full_name

                return it
            dataCollection.epic = _.map data.epics, (it) ->
                if it.id
                    it.id = it.id.toString()
                    it.name = "##{it.ref} #{it.subject}"
                else
                    it.id = "null"
                    it.name = "Not in an epic"

                return it

            @.selectedFilters = []

            for key in @.filterCategories
                excludeKey = @.excludePrefix.concat(key)
                if loadFilters[key]
                    selected = @.formatSelectedFilters(key, dataCollection[key], loadFilters[key])
                    @.selectedFilters = @.selectedFilters.concat(selected)
                if loadFilters[excludeKey]
                    selected = @.formatSelectedFilters(key, dataCollection[key], loadFilters[excludeKey], "exclude")
                    @.selectedFilters = @.selectedFilters.concat(selected)

            @.filterQ = loadFilters.q

            @.filters = [
                {
                    title: @translate.instant("COMMON.FILTERS.CATEGORIES.STATUS"),
                    dataType: "status",
                    content: dataCollection.status
                },
                {
                    title: @translate.instant("COMMON.FILTERS.CATEGORIES.TAGS"),
                    dataType: "tags",
                    content: dataCollection.tags,
                    hideEmpty: true,
                    totalTaggedElements: tagsWithAtLeastOneElement.length
                },
                {
                    title: @translate.instant("COMMON.FILTERS.CATEGORIES.ASSIGNED_USERS"),
                    dataType: "assigned_users",
                    content: dataCollection.assigned_users
                },
                {
                    title: @translate.instant("COMMON.FILTERS.CATEGORIES.ROLE"),
                    dataType: "role",
                    content: dataCollection.role
                },
                {
                    title: @translate.instant("COMMON.FILTERS.CATEGORIES.CREATED_BY"),
                    dataType: "owner",
                    content: dataCollection.owner
                },
                {
                    title: @translate.instant("COMMON.FILTERS.CATEGORIES.EPIC"),
                    dataType: "epic",
                    content: dataCollection.epic
                }
            ]

            @.customFilters = []
            _.forOwn customFiltersRaw, (value, key) =>
                @.customFilters.push({id: key, name: key, filter: value})


tuesmon.UsFiltersMixin = UsFiltersMixin
