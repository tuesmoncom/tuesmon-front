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
# File: projects/create/import-project-members/import-project-members.controller.coffee
###

class ImportProjectMembersController
    @.$inject = [
        'tgCurrentUserService',
        'tgUserService'
    ]

    constructor: (@currentUserService, @userService) ->
        @.selectImportUserLightbox = false
        @.warningImportUsers = false
        @.displayEmailSelector = true
        @.cancelledUsers = Immutable.List()
        @.selectedUsers = Immutable.List()
        @.selectableUsers = Immutable.List()
        @.userContacts = Immutable.List()

    fetchUser: () ->
        @.currentUser = @currentUserService.getUser()

        @userService.getContacts(@.currentUser.get('id')).then (userContacts) =>
            @.userContacts = userContacts
            @.refreshSelectableUsers()

    searchUser: (user) ->
        @.selectImportUserLightbox = true
        @.searchingUser = user

    beforeSubmitUsers: () ->
        if @.selectedUsers.size != @.members.size
            @.warningImportUsers = true
        else
            @.submit()

    confirmUser: (externalUser, tuesmonUser) ->
        @.selectImportUserLightbox = false

        user = Immutable.Map()
        user = user.set('user', externalUser)
        user = user.set('tuesmonUser', tuesmonUser)

        @.selectedUsers = @.selectedUsers.push(user)

        @.discardSuggestedUser(externalUser)

        @.refreshSelectableUsers()

    unselectUser: (user) ->
        index = @.selectedUsers.findIndex (it) -> it.getIn(['user', 'id']) == user.get('id')

        @.selectedUsers = @.selectedUsers.delete(index)
        @.refreshSelectableUsers()

    discardSuggestedUser: (member) ->
        @.cancelledUsers = @.cancelledUsers.push(member.get('id'))

    getSelectedMember: (member) ->
        return @.selectedUsers.find (it) ->
            return it.getIn(['user', 'id']) == member.get('id')

    isMemberSelected: (member) ->
        return !!@.getSelectedMember(member)

    getUser: (user) ->
        userSelected = @.getSelectedMember(user)

        if userSelected
            return userSelected.get('tuesmonUser')
        else
            return null

    submit: () ->
        @.warningImportUsers = false

        users = Immutable.Map()

        @.selectedUsers.map (it) ->
            id = ''

            if _.isString(it.get('tuesmonUser'))
                id = it.get('tuesmonUser')
            else
                id = it.getIn(['tuesmonUser', 'id'])

            users = users.set(it.getIn(['user', 'id']), id)

        @.onSubmit({users: users})

    checkUsersLimit: () ->
        @.limitMembersPrivateProject = @currentUserService.canAddMembersPrivateProject(@.members.size + 1)
        @.limitMembersPublicProject = @currentUserService.canAddMembersPublicProject(@.members.size + 1)

    showSuggestedMatch: (member) ->
        return member.get('user') && @.cancelledUsers.indexOf(member.get('id')) == -1 && !@.isMemberSelected(member)

    getDistinctSelectedTuesmonUsers: () ->
        ids = []

        users = @.selectedUsers.filter (it) ->
            id = it.getIn(['tuesmonUser', 'id'])

            if ids.indexOf(id) == -1
                ids.push(id)
                return true

            return false

        return users.filter (it) =>
            return it.getIn(['tuesmonUser', 'id']) != @.currentUser.get('id')

    refreshSelectableUsers: () ->
        @.importMoreUsersDisabled = @.isImportMoreUsersDisabled()

        if @.importMoreUsersDisabled
            users = @.getDistinctSelectedTuesmonUsers()

            @.selectableUsers = users.map (it) -> return it.get('tuesmonUser')
            @.displayEmailSelector = false
        else
            @.selectableUsers = @.userContacts
            @.displayEmailSelector = true

        @.selectableUsers = @.selectableUsers.push(@.currentUser)

    isImportMoreUsersDisabled: () ->
        users = @.getDistinctSelectedTuesmonUsers()

        # currentUser + newUser = +2
        total = users.size + 2


        if @.project.get('is_private')
            return !@currentUserService.canAddMembersPrivateProject(total).valid
        else
            return !@currentUserService.canAddMembersPublicProject(total).valid

angular.module('tuesmonProjects').controller('ImportProjectMembersCtrl', ImportProjectMembersController)
