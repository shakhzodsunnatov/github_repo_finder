//
//  RepositoriesModel.swift
//  github_test
//
//  Created by Shokhzod on 08/07/22.
//

import Foundation



import Foundation

// MARK: - RepositorieElement
struct RepositorieElement: Codable {
    let id: Int?
    let nodeID, name, fullName: String?
    let owner: Owner?
    let repositoriePrivate: Bool?
    let htmlURL: String?
    let repositorieDescription: String?
    let fork: Bool?
    let url: String?
    let archiveURL, assigneesURL, blobsURL, branchesURL: String?
    let collaboratorsURL, commentsURL, commitsURL, compareURL: String?
    let contentsURL: String?
    let contributorsURL, deploymentsURL, downloadsURL, eventsURL: String?
    let forksURL: String?
    let gitCommitsURL, gitRefsURL, gitTagsURL, gitURL: String?
    let issueCommentURL, issueEventsURL, issuesURL, keysURL: String?
    let labelsURL: String?
    let languagesURL, mergesURL: String?
    let milestonesURL, notificationsURL, pullsURL, releasesURL: String?
    let sshURL: String?
    let stargazersURL: String?
    let statusesURL: String?
    let subscribersURL, subscriptionURL, tagsURL, teamsURL: String?
    let treesURL: String?
    let hooksURL: String?

    enum CodingKeys: String, CodingKey {
        case id
        case nodeID = "node_id"
        case name
        case fullName = "full_name"
        case owner
        case repositoriePrivate = "private"
        case htmlURL = "html_url"
        case repositorieDescription = "description"
        case fork, url
        case archiveURL = "archive_url"
        case assigneesURL = "assignees_url"
        case blobsURL = "blobs_url"
        case branchesURL = "branches_url"
        case collaboratorsURL = "collaborators_url"
        case commentsURL = "comments_url"
        case commitsURL = "commits_url"
        case compareURL = "compare_url"
        case contentsURL = "contents_url"
        case contributorsURL = "contributors_url"
        case deploymentsURL = "deployments_url"
        case downloadsURL = "downloads_url"
        case eventsURL = "events_url"
        case forksURL = "forks_url"
        case gitCommitsURL = "git_commits_url"
        case gitRefsURL = "git_refs_url"
        case gitTagsURL = "git_tags_url"
        case gitURL = "git_url"
        case issueCommentURL = "issue_comment_url"
        case issueEventsURL = "issue_events_url"
        case issuesURL = "issues_url"
        case keysURL = "keys_url"
        case labelsURL = "labels_url"
        case languagesURL = "languages_url"
        case mergesURL = "merges_url"
        case milestonesURL = "milestones_url"
        case notificationsURL = "notifications_url"
        case pullsURL = "pulls_url"
        case releasesURL = "releases_url"
        case sshURL = "ssh_url"
        case stargazersURL = "stargazers_url"
        case statusesURL = "statuses_url"
        case subscribersURL = "subscribers_url"
        case subscriptionURL = "subscription_url"
        case tagsURL = "tags_url"
        case teamsURL = "teams_url"
        case treesURL = "trees_url"
        case hooksURL = "hooks_url"
    }
}

// MARK: - Owner
struct Owner: Codable {
    let login: String?
    let id: Int?
    let nodeID: String?
    let avatarURL: String?
    let gravatarID: String?
    let url, htmlURL, followersURL: String?
    let followingURL, gistsURL, starredURL: String?
    let subscriptionsURL, organizationsURL, reposURL: String?
    let eventsURL: String?
    let receivedEventsURL: String?
    let type: String?
    let siteAdmin: Bool?

    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case url
        case htmlURL = "html_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case gistsURL = "gists_url"
        case starredURL = "starred_url"
        case subscriptionsURL = "subscriptions_url"
        case organizationsURL = "organizations_url"
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case receivedEventsURL = "received_events_url"
        case type
        case siteAdmin = "site_admin"
    }
}

typealias Repositorie = [RepositorieElement]

