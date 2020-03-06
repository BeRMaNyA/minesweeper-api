# MineSweeper-API 

This API was developed with [fit-api](https://github.com/BeRMaNyA/fit-api), an experimental library developed by myself.  
FitApi is based on Rack and aims to speed up the API development with Ruby.

You can check the [demo here](https://minesweeper-berna.herokuapp.com/)

## Table of Contents

* [MineSweeper-API](#fit-api)
    * [Table of Contents](#table-of-contents)
    * [Dependencies](#dependencies)
    * [Running the tests](#running-the-tests)
    * [Running the app](#running-the-app)
    * [App Console](#app-console)
    * [Endpoints](#endpoints)
        * [Signup](#signup)
        * [Auth](#auth)
        * [List Games](#list-games)
        * [Create a Game](#create-a-game)
        * [Delete a Game](#delete-a-game)
        * [Pause a Game](#pause-a-game)
        * [Resume a Game](#resume-a-game)
        * [Board](#board)
        * [Check a Cell](#check-a-cell)
        * [Flag a Cell](#flag-a-cell)
        * [Unflag a Cell](#unflag-a-cell)

## Dependencies

### Services

You need to install

- [Bundler](https://bundler.io/)
- [MongoDB](https://mongodb.com)

### Gems

```bash
$ bundle install
```

## Running the tests

```bash
$ rspec spec/
```

## Running the app

Don't forget to edit the `.env` file.

```bash
$ rackup -p 3000
```

### App Console

```bash
$ pry
```

## Endpoints

You should set these env vars so you can just copy-paste the curls examples:

```bash
export GAMEHOST="https://minesweeper-berna.herokuapp.com"
export BEARER="" # copy your jwt token
export GAMEID="" # copy your created game id
```

### Signup

```http
POST /users
```

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `name` | `string` | **Required**. User full name |
| `username` | `string` | **Required**. User alias |
| `password` | `password` | **Required**. User password |

Curl request:

```bash
curl $GAMEHOST/users \
-H "Content-Type: application/json" \
-d '{ "name": "Joe Doe", "username": "joedoe", "password": "123456" }'
```

#### Response

```javascript
{
  "user": {
    "id": "5e5e9ff248dd4265db8e753d",
    "name": "Joe Doe",
    "username": "joedoe",
    "token": "eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE1ODMyNjMyMzQsImlhdCI6MTU4MzI1OTYzNCwiaXNzIjoibWluZXN3ZWVwZXItYXBpLmNvbSIsInNjb3BlcyI6WyJsaXN0X2dhbWVzIiwiY3JlYXRlX2dhbWUiLCJkZWxldGVfZ2FtZSIsInBsYXlfZ2FtZSJdLCJ1c2VyIjp7ImlkIjoiNWU1ZTlmZjI0OGRkNDI2NWRiOGU3NTNkIn19.nf5_ffzAwwltUlmAptA5F6kq6aZPjmKawUPAuGtin1k"
  }
}
```

```bash
export BEARER="eyJhbGciOiJIUzI1Ni..."
```

### Auth

You need to pass the JWT token into the headers.

```http
POST /login
```

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `username` | `string` | **Required**. Login |
| `password` | `string` | **Required**. User password |

Curl request:

```bash
curl $GAMEHOST/login \
-H "Content-Type: application/json" \
-d '{ "username": "joedoe", "password": "123456" }'
```

#### Response

```javascript
{
  "token": "eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE1ODMyNjMyMzQsImlhdCI6MTU4MzI1OTYzNCwiaXNzIjoibWluZXN3ZWVwZXItYXBpLmNvbSIsInNjb3BlcyI6WyJsaXN0X2dhbWVzIiwiY3JlYXRlX2dhbWUiLCJkZWxldGVfZ2FtZSIsInBsYXlfZ2FtZSJdLCJ1c2VyIjp7ImlkIjoiNWU1ZTlmZjI0OGRkNDI2NWRiOGU3NTNkIn19.nf5_ffzAwwltUlmAptA5F6kq6aZPjmKawUPAuGtin1k"
}
```

```bash
export BEARER="eyJhbGciOiJIUzI1Ni..."
```

### List Games

```http
GET /games
```

Curl request:

```bash
curl $GAMEHOST/games \
-H "Authorization: Bearer $BEARER" \
-H "Content-Type: application/json"
```

#### Response

```javascript
{
  "games": [
    {
      "id": "5e62299f48dd42413e6d5b21",
      "name": "Hello World",
      "state": "playing",
      "duration": 76.6,
      "time_entries": [
        {
          "id": "5e62299f48dd42413e6d5b22",
          "start_time": "2020-03-06 11:44:47 +0100",
          "end_time": null,
          "duration": 76.6
        }
      ]
    },
    {
      "id": "5e62298b48dd42413e6d5aba",
      "name": "Hello World",
      "state": "playing",
      "duration": 96.66,
      "time_entries": [
        {
          "id": "5e62298b48dd42413e6d5abb",
          "start_time": "2020-03-06 11:44:27 +0100",
          "end_time": null,
          "duration": 96.66
        }
      ]
    }
  ],
  "pagination": {
    "total_pages": 1,
    "current_page": 1,
    "next_page": null,
    "prev_page": null
  }
}
```

### Create a Game

```http
POST /games
```

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `name` | `string` | **Required**. Game name |
| `board[rows]` | `integer` | **Optional**. Board rows number. |
| `board[cols]` | `integer` | **Optional**. Board cols number |
| `board[mines]` | `integer` | **Optional**. Number of mines |

Curl request:

```bash
curl $GAMEHOST/games \
-H "Authorization: Bearer $BEARER" \
-H "Content-Type: application/json" \
-d '{ "name": "Hello World", "board": { "rows": "2", "cols": "2", "mines": "1" } }'
```

#### Response

```javascript
{
  "game": {
    "id": "5e62299f48dd42413e6d5b21",
    "name": "Hello World",
    "state": "playing",
    "duration": 0.0,
    "time_entries": [
      {
        "id": "5e62299f48dd42413e6d5b22",
        "start_time": "2020-03-06 11:44:47 +0100",
        "end_time": null,
        "duration": 0.0
      }
    ],
    "board": {
      "mines": 1,
      "rows": 2,
      "cols": 2,
      "hidden": 4,
      "mine_ids": null,
      "cells": [
        [
          {
            "id": "5e62299f48dd42413e6d5b23",
            "y": 0,
            "x": 0,
            "state": "hidden",
            "has_mine": false,
            "flag_value": null
          },
          {
            "id": "5e62299f48dd42413e6d5b24",
            "y": 0,
            "x": 1,
            "state": "hidden",
            "has_mine": false,
            "flag_value": null
          }
        ],
        [
          {
            "id": "5e62299f48dd42413e6d5b25",
            "y": 1,
            "x": 0,
            "state": "hidden",
            "has_mine": false,
            "flag_value": null
          },
          {
            "id": "5e62299f48dd42413e6d5b26",
            "y": 1,
            "x": 1,
            "state": "hidden",
            "has_mine": false,
            "flag_value": null
          }
        ]
      ]
    }
  }
}
```

```bash
export GAMEID="5e5ea3f148dd4265db8e7565"
```

### Delete a Game

```http
DELETE /games/:id 
```

Curl request:

```bash
curl -i -X DELETE $GAMEHOST/games/$GAMEID \
-H "Authorization: Bearer $BEARER" \
-H "Content-Type: application/json"
```

#### Response

```javascript
{
  "game": {
    "id": "5e5ea3f148dd4265db8e7565",
    "name": "Hello World",
    "state": "deleted",
    "mines": 3,
    "rows": 6,
    "cols": 6,
    "time_entries": [
      {
        "id": "5e5ea3f148dd4265db8e7566",
        "start_time": "2020-03-03 19:37:37 +0100",
        "end_time": null,
        "duration": null
      }
    ]
  }
}
```

### Pause a Game

```http
POST /games/:id/pause
```

Curl request:

```bash
curl -i -X POST $GAMEHOST/games/$GAMEID/pause \
-H "Authorization: Bearer $BEARER" \
-H "Content-Type: application/json" \
-d ""
```

#### Response

```javascript
{
  success: true
}
```

### Resume A Game

```http
POST /games/:id/resume
```

Curl request:

```bash
curl -i -X POST $GAMEHOST/games/$GAMEID/resume \
-H "Authorization: Bearer $BEARER" \
-H "Content-Type: application/json" \
-d ""
```

#### Response

```javascript
{
  success: true
}
```

### Board

```http
GET /games/:id/board
```

Curl request:

```bash
curl $GAMEHOST/games/$GAMEID/board \
-H "Authorization: Bearer $BEARER" \
-H "Content-Type: application/json"
```

#### Response

```javascript
{
  "board": {
    "mines": 1,
    "rows": 2,
    "cols": 2,
    "hidden": 4,
    "mine_ids": null,
    "cells": [
      [
        {
          "id": "5e62299f48dd42413e6d5b23",
          "y": 0,
          "x": 0,
          "state": "hidden",
          "has_mine": false,
          "flag_value": null
        },
        ...
      ]
      ...
    ]
  }
}
```

### Check a Cell

```http
POST /games/:id/board/check
```

| Parameter | Type      | Description |
| :---      | :---      | :---        |
| `x`       | `integer` | **Required**. Cell position |
| `y`       | `integer` | **Required**. Cell position |

Curl request:

```bash
curl $GAMEHOST/games/$GAMEID/board/check \
-H "Authorization: Bearer $BEARER" \
-H "Content-Type: application/json" \
-d '{"x":"0", "y":"0"}'
```

#### Response

Returns the affected cells:

```javascript
{
  "cells": [ ... ],
  "win": false
}
```

or

```javascript
{
  game_over: true
}
```

### Flag a Cell

```http
POST /games/:id/board/flag
```

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `type` | `string`  | **Required**. Flag type |
| `x`    | `integer` | **Required**. Cell position |
| `y`    | `integer` | **Required**. Cell position |

Curl request:

```bash
curl $GAMEHOST/games/$GAMEID/board/flag \
-H "Authorization: Bearer $BEARER" \
-H "Content-Type: application/json" \
-d '{"type":"flag", "x":"0", "y":"0"}'
```

#### Response

Returns the affected cells:

```javascript
{
  "cell": { ... },
  "win": false
}
```

### Unflag a Cell

```http
POST /games/:id/board/unflag
```

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `x`    | `integer` | **Required**. Cell position |
| `y`    | `integer` | **Required**. Cell position |

Curl request:

```bash
curl $GAMEHOST/games/$GAMEID/board/unflag \
-H "Authorization: Bearer $BEARER" \
-H "Content-Type: application/json" \
-d '{"x":"0", "y":"0"}'
```

#### Response

Returns the affected cells:

```javascript
{
  "cell": { ... },
}
```
