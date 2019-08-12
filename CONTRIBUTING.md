# How can I contribute to Tuesmon?

---

## Developer Certificate of Origin + License

By contributing to Tuesmon Agile LLC., You accept and agree to the following terms and conditions for Your present and future Contributions submitted to Tuesmon Agile LLC. Except for the license granted herein to Tuesmon Agile LLC. and recipients of software distributed by Tuesmon Agile LLC., You reserve all right, title, and interest in and to Your Contributions.

All Contributions are subject to the following DCO + License terms.

[DCO + License](https://github.com/tuesmon/tuesmon-front/blob/master/DCOLICENSE)

_This notice should stay as the first item in the CONTRIBUTING.md file._

---

We will be very happy to help us to improve Tuesmon, there are many different ways to contribute to Tuesmon's development, just find the one that best fits with your skills. Here are the guidelines we'd like you to follow.

## Our Code of Conduct

Help us keep the Tuesmon Community open and inclusive. Please read and follow our [Code of Conduct][CoC].

## Our License

Every code patch accepted in Tuesmon codebase is licensed under [AGPL v3.0][AGPL v3.0]. You must be careful to not include any code that can not be licensed under this license.

Please read carefully [our license][Tuesmon license] and ask us if you have any questions.

## Setup problems

If you follow our [setup guide][tuesmon Dev/Setup documentation] and you have some problem, please tell with us in our [mailing list][Tuesmon Mailing List].

## Sent us your feedback or questions

If you want to send us your feedback or have some questions about how to use Tuesmon, please direct these to our [mailing list][Tuesmon Mailing List]. If it's related to our SaaS https://tuesmon.com please write us to our support email [support@tuesmon.com][Support email].

Remember that you can find some help in our [support pages][Tuesmon User documentation].

## Did you find an issue or bug?

If you find an issue using the app (UX or UI bug) or reading our source code and it's not on our [Bug list][Tuesmon Bug list] at Tuesmon.com, please report it:

- in our [mailing list][Tuesmon Mailing List]
- in the issue section of the appropriate repository at [GitHub][Tuesmon in GitHub].
- send us a mail to [support@tuesmon.com][Support email] if is a bug related to [manage.tuesmon.com][Tuesmon.com].
- send a mail to [security@tuesmon.com][Security email] if is a **security bug**.

Even better: you can submit a Pull Request with a fix.

Please, before reporting a bug write down

- explain why this is a bug for you
- how can we reproduce it
- your operating System
- your browser and version
- if it's possible, a screenshot

Sometimes it takes less time to fix a bug if the developer knows how to find it and we will solve your problem as fast as possible.

**Localization Issue:** Tuesmon use Transifex to manage the i18n files so don't submit a pull request to those files (except `-en.json`), to fix it just access our team of translators, set up an account in the [Tuesmon Transifex project][Tuesmon in Transifex] and start contributing.

## Propose some feature or enhancement

You can propose a new enhancement to our [mailing list][Tuesmon Mailing List] or review and upvote in the existing [list of enhancements][Tuesmon Enhancement list] in Tuesmon.com.

If you would like to implement it by yourself consider what kind of change it is:

### Small Changes

It can be crafted and submitted to the [GitHub Repositories][Tuesmon in GitHub] as a Pull Request.

### Major Changes

Before contributing with a major change to Tuesmon it should be discussed first with the Tuesmon Team so that we can better coordinate our efforts, prevent duplication of work, and help you to craft the change so that it is successfully accepted into the project. Please, contact us in the [mailing list][Tuesmon mailing list] or via [support@tuesmon.com][Support email].

We have defined a concrete workflow for this changes:

1. **User Story**: Send us a complete description of the functionality you'd like to develop, how it should work, for which profiles, as if you were writing a User Story. Please include some ideas of what would be a definition of Done of the User Story. The team will review it, decide whether or not it could make it into Tuesmon Core. If not, you can always write a plugin.
2. **Mentorship**: If accepted, Tuesmon team will help you, and a person from the team will be your contact in the development process. The Story will be visible in the [Tuesmon Kanban][Tuesmon Kanban]
3. **User Experience**: The functionality will require some wireframes or ideas to be developed correctly. A good UX its an essential part of Tuesmon success. You should create a user experience proposal and the Tuesmon UX team will help you.
4. **Design**: The design should respect the Tuesmon style. Try to reproduce other areas of the site. The tuesmon design team will review this proposal as well.
5. **Development**: The last step is the development. Remember to add unit and integration test in `tuesmon-back` code and unit and e2e test for `tuesmon-front` part. We have the API well documented too in [tuesmon-doc][Tuesmon Dev/Setup documentation].
6. **Pull request**: Remember to add a good description and screenshots are welcome too. Once the pull request is done, someone else from the team will review the code to ensure that it fits with the good practices and styles. If it does, the PR will be merged and will be on the next Tuesmon release.

If you think you are not able to do one or more of the parts of the process, your contribution is still welcome, but we cannot ensure that it will make it soon into the Tuesmon core anytime soon. It will depend on our priority backlog.

Thanks a lot! It is really great that we could make Tuesmon better with the help of the community.

### Contrib plugins

Tuesmon support contrib plugins to add or overwrite some functionalities. You can find some example in [our organization at GitHub][Tuesmon in GitHub].

## Improve the documentation

We are gathering lots of information from our users to build and enhance our documentation. If you use the documentation to install or develop with Tuesmon and find any mistakes, omissions or confused sequences, it is enormously helpful to report it. Or better still, if you believe you can author additions, please make a pull-request to tuesmon project.

Currently, we have authored three main documentation hubs:

- [Tuesmon Setup/Dev documentation][Tuesmon Dev/Setup documentation repo]: If you need to install Tuesmon on your own server, this is the place to find some guides or our API documentation and reference for developing from Tuesmon API.
- [Tuesmon User documentation][Tuesmon User documentation repo]: This page is intended to be the support reference page for the users. If you find any mistake, please report or fix it.

[Tuesmon.com]: https://tuesmon.com

[CoC]: https://github.com/tuesmoncom/code-of-conduct/blob/master/CODE_OF_CONDUCT.md
[AGPL v3.0]: http://www.gnu.org/licenses/agpl-3.0.html
[Tuesmon license]: https://github.com/tuesmoncom/tuesmon-back/blob/master/LICENSE

[Tuesmon Mailing List]: http://groups.google.co.uk/d/forum/tuesmoncom
[Support email]: mailto:support@tuesmon.com
[Security email]: mailto:security@tuesmon.com

[Tuesmon in Transifex]: https://www.transifex.com/organization/tuesmon-agile-llc/
[Tuesmon in GitHub]: https://github.com/tuesmoncom

[Tuesmon kanban]: https://manage.tuesmon.com/project/tuesmon/kanban
[Tuesmon Bug list]: https://manage.tuesmon.com/project/tuesmon/issues?statuses=1,2&orderBy=-created_date&page=1&types=1
[Tuesmon Enhancement list]: https://manage.tuesmon.com/project/tuesmon/issues?statuses=1,2&orderBy=-total_voters&page=1&status=1,2&types=6

[Tuesmon Dev/Setup documentation]: http://tuesmoncom.github.io/tuesmon-doc/dist/
[Tuesmon Dev/Setup documentation repo]: https://github.com/tuesmoncom/tuesmon-doc
[Tuesmon User documentation]: https://manage.tuesmon.com/support/
[Tuesmon User documentation repo]: https://github.com/tuesmoncom/tuesmon-support
