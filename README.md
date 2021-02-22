# Redmine Plugin Webhook

A plugin for Redmine which makes callback requests to specified URL when issue changes.

## Requirements

- Redmine 3.4+
- [Relevant ruby and rails versions](http://www.redmine.org/projects/redmine/wiki/redmineinstall)
- This plugin does not have any other dependencies

**Note**: this plugin was tested with Redmine 3.4.4 and 3.4.8

## Installation

1. `cd` into `plugins` folder
2. `git clone https://github.com/ostrovok-team/redmine-plugin-webhook.git webhook`
4. Restart redmine server
5. Now you should be able to see the plugin in **Administration > Plugins**.

**Note**: it is important that the plugin directory is named `webhook`, otherwise it will not load. Prior to Redmine 4 plugin loading fails silently and you will see 404 on configuration page.

## Usage

Go to `Administration - Plugins - Redmine Webhook Plugin - Configure`, enter URL and click `Apply`

![Configure tab](redmine-webhook-plugin-settings.jpg)

Example payload on issue update:

```
{
  "payload": {
    "action": "updated",
    "issue": {
      "id": 60607,
      "subject": "Test 121",
      "description": "desctiption",
      "created_on": "2019-02-15T13:19:06.625Z",
      "updated_on": "2019-03-29T21:06:04.405Z",
      "closed_on": null,
      "root_id": 60607,
      "parent_id": null,
      "done_ratio": 0,
      "start_date": null,
      "due_date": null,
      "estimated_hours": null,
      "is_private": false,
      "lock_version": 12,
      "custom_field_values": [
        {
          "custom_field_id": 2,
          "custom_field_name": "Custom field",
          "value": "Custom value"
        }
      ],
      "project": {
        "id": 32,
        "identifier": "team",
        "name": "Great team",
        "description": "",
        "created_on": "2012-11-06T14:39:27.104Z",
        "homepage": ""
      },
      "status": {
        "id": 1,
        "name": "Open"
      },
      "tracker": {
        "id": 2,
        "name": "Feature"
      },
      "priority": {
        "id": 4,
        "name": "Normal"
      },
      "author": {
        "id": 1,
        "login": "irina",
        "mail": "irina@domain.com",
        "firstname": "Irina",
        "lastname": "Lastname",
        "identity_url": null,
        "icon_url": "//www.gravatar.com/avatar/..."
      },
      "assignee": {
        "id": 2,
        "login": "ivan",
        "mail": "ivan@domain.com",
        "firstname": "Ivan",
        "lastname": "Lastname",
        "identity_url": null,
        "icon_url": "//www.gravatar.com/avatar/..."
      },
      "watchers": [
        {
          "id": 1,
          "login": "irina",
          "mail": "irina@domain.com",
          "firstname": "Irina",
          "lastname": "Lastname",
          "identity_url": null,
          "icon_url": "//www.gravatar.com/avatar/..."
        }
      ]
    },
    "journal": {
      "id": 395893,
      "notes": "",
      "created_on": "2019-03-29T21:06:04.725Z",
      "private_notes": false,
      "author": {
        "id": 3,
        "login": "sergey",
        "mail": "sergey@domain.com",
        "firstname": "Sergey",
        "lastname": "Lastname",
        "identity_url": null,
        "icon_url": "//www.gravatar.com/avatar/..."
      },
      "details": [
        {
          "id": 404625,
          "value": "10",
          "old_value": "20",
          "prop_key": "status_id",
          "property": "attr"
        },
        {
          "id": 404626,
          "value": "257",
          "old_value": null,
          "prop_key": "assigned_to_id",
          "property": "attr"
        }
      ]
    },
    "url": "http://localhost:8000/issues/60607"
  }
}
```

## Maintainers

- [@biozz](https://github.com/biozz)
