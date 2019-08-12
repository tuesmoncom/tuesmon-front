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
# File: modules/resources/history.coffee
###


tuesmon = @.tuesmon

resourceProvider = ($repo, $http, $urls) ->
    service = {}

    service.get = (contentType, objectId, entryType) ->
        return $repo.queryOneRaw("history/#{contentType}", objectId, {type: entryType})

    service.editComment = (type, objectId, activityId, comment) ->
        url = $urls.resolve("history/#{type}")
        url = "#{url}/#{objectId}/edit_comment"
        params = {
            id: activityId
        }
        commentData = {
            comment: comment
        }
        return $http.post(url, commentData, params).then (data) =>
            return data.data

    service.getCommentHistory = (type, objectId, activityId) ->
        url = $urls.resolve("history/#{type}")
        url = "#{url}/#{objectId}/comment_versions"
        params = {id: activityId}
        return $http.get(url, params).then (data) =>
            return data.data

    service.deleteComment = (type, objectId, activityId) ->
        url = $urls.resolve("history/#{type}")
        url = "#{url}/#{objectId}/delete_comment"
        params = {id: activityId}
        return $http.post(url, null, params).then (data) =>
            return data.data

    service.undeleteComment = (type, objectId, activityId) ->
        url = $urls.resolve("history/#{type}")
        url = "#{url}/#{objectId}/undelete_comment"
        params = {id: activityId}
        return $http.post(url, null, params).then (data) =>
            return data.data

    return (instance) ->
        instance.history = service


module = angular.module("tuesmonResources")
module.factory("$tgHistoryResourcesProvider", ["$tgRepo", "$tgHttp", "$tgUrls", resourceProvider])
