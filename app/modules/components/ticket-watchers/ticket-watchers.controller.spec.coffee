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
# File: components/watch-button/watch-button.controller.spec.coffee
###

describe "TicketWatchersController", ->
    provide = null
    $controller = null
    $rootScope = null
    mocks = {}

    _mockCurrentUser = () ->
        mocks.currentUser = {
            getUser: sinon.stub()
        }

        provide.value "tgCurrentUserService", mocks.currentUser

    _mocks = ->
        mocks = {
            onWatch: sinon.stub(),
            onUnwatch: sinon.stub()
        }

        module ($provide) ->
            provide = $provide
            _mockCurrentUser()
            _mockTgLightboxFactory()
            _mockTranslate()
            _mockModelTransform()

            return null

    _mockTgLightboxFactory = () ->
        mocks.tgLightboxFactory = {
            create: sinon.stub()
        }

        provide.value "tgLightboxFactory", mocks.tgLightboxFactory

    _mockTranslate = () ->
        mocks.translate = sinon.stub()

        provide.value "$translate", mocks.translate

    _mockModelTransform = () ->
        mocks.modelTransform = sinon.stub()

        provide.value "$tgQueueModelTransformation", mocks.modelTransform

    _inject = (callback) ->
        inject (_$controller_, _$rootScope_) ->
            $rootScope = _$rootScope_
            $controller = _$controller_

    _setup = ->
        _mocks()
        _inject()

    beforeEach ->
        module "tuesmonComponents"
        _setup()

    it "watch", (done) ->
        $scope = $rootScope.$new()

        mocks.onWatch = sinon.stub().promise()

        ctrl = $controller("TicketWatchersController", $scope, {
            item: {is_watcher: false}
            onWatch: mocks.onWatch
            onUnwatch: mocks.onUnwatch
        })


        promise = ctrl.watch()

        expect(ctrl.loading).to.be.true

        mocks.onWatch.resolve()

        promise.finally () ->
            expect(mocks.onWatch).to.be.calledOnce
            expect(ctrl.loading).to.be.false

            done()

    it "unwatch", (done) ->
        $scope = $rootScope.$new()

        mocks.onUnwatch = sinon.stub().promise()

        ctrl = $controller("TicketWatchersController", $scope, {
            item: {is_watcher: true}
            onWatch: mocks.onWatch
            onUnwatch: mocks.onUnwatch
        })

        promise = ctrl.unwatch()

        expect(ctrl.loading).to.be.true

        mocks.onUnwatch.resolve()

        promise.finally () ->
            expect(mocks.onUnwatch).to.be.calledOnce
            expect(ctrl.loading).to.be.false

            done()


    it "get permissions", () ->
        $scope = $rootScope.$new()

        ctrl = $controller("TicketWatchersController", $scope, {
            item: {_name: 'tasks'}
        })

        perm = ctrl.getPerms()
        expect(perm).to.be.equal('modify_task')

        ctrl.item = {_name: 'issues'}

        perm = ctrl.getPerms()
        expect(perm).to.be.equal('modify_issue')

        ctrl.item = {_name: 'userstories'}

        perm = ctrl.getPerms()
        expect(perm).to.be.equal('modify_us')
