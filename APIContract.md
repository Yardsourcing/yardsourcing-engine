# Yardsourcing API Contract

## Endpoints

| HTTP verbs | Paths  | Used for | Output |
| ---------- | ------ | -------- | ------:|
| GET | /api/v1/purposes | Get the available purposes | [json](#purposes) |
| GET | /api/v1/yards/:yard_id  | Get a yard's show page | [json](#yard-details) |
| GET | /api/v1/yards/:yard_id/purposes  | Get a yard's purposes | [json](#yard-purposes) |
| POST | /api/v1/yards  | Create a new yard | [json](#create-a-yard) |
| DELETE | /api/v1/yards/:yard_id  | Delete a yard | [details](#delete-a-yard) |
| PUT | /api/v1/yards/:yard_id | Update a yard | [json](#update-a-yard)
| GET | /api/v1/hosts/host_id/bookings?status=STATUS | Get all bookings for a host that have a particular status| [json](#get-user-bookings-by-status) |
| GET | /api/v1/renters/renter_id/bookings?status=STATUS | Get all bookings for a renter that have a particular status| [json](#get-user-bookings-by-status) |
| GET | /api/v1/yards?location=ZIP&purposes=PURPOSE+NAME&OTHER+PURPOSE+NAME  | Get yards that match search criteria. | [json](#yard-search) |
| GET | /api/v1/hosts/host_id/yards  | Get yards that belong to a host | [json](#user-yards) |
| GET | /api/v1/yards/:yard_id/bookings | Get bookings that belong to a specific yard | [json](#yard-bookings) |
| POST | /api/v1/bookings | Create a new booking | [json](#create-a-booking) |
| GET | /api/v1/bookings/:booking_id | Get booking show page | [json](#booking-details) |
| DELETE | /api/v1/bookings/:booking_id | Delete a new booking | [details](#delete-a-booking) |


## JSON Responses

## Purposes
`GET /api/v1/purposes`
  ```json
  {
    "data": [
      {
        "id": "1",
          "type": "purpose",
          "attributes": {
            "name": "Pet Rental",
          }
      },
      {
        "id": "2",
        "type": "purpose",
          "attributes": {
            "name": "Party Rental",
          }
      },
      {
        "id": "3",
        "type": "yard",
          "attributes": {
            "name": "Hobby Rental",
          }
      }
    ]
  }
  ```

## Yard Details
`GET /api/v1/yards/:yard_id`
  ```json
  {
    "data": {
      "id": "1",
      "type": "yard",
      "attributes": {
        "host_id": "1",
        "name": "Mike's Awesome Yard",
        "street_address": "123 Baker Street",
        "city": "Philadelphia",
        "state": "PA",
        "zipcode": "19125",
        "price": 10.50,
        "description": "This yard is green and 1200 sf",
        "payment": "venmo/paypal infomraiton?",
        "availability": "weekends and weekdays after 5pm",
        "photo_url_1": "https:picture1.org",
        "photo_url_2": "",
        "photo_url_3": "",
        "purposes": {
          "data": [
            {
              "id": "1",
              "type": "purpose",
              "attributes": {
                "name": "Pet Rental",
              }
            },
            {
              "id": "2",
              "type": "purpose",
              "attributes": {
                "name": "Party Rental",
              }
            }
          ]
        }
        }
      }
    }
  }
  ```

## Yard Purposes
  `GET /api/v1/purposes`
  ```json
  {
    "data": [
      {
        "id": "1",
          "type": "purpose",
          "attributes": {
            "name": "Pet Rental",
          }
      },
      {
        "id": "2",
        "type": "purpose",
          "attributes": {
            "name": "Party Rental",
          }
      }
    ]
  }
  ```

## Create a Yard
`POST /api/v1/yards`
  ```json
    {
      "host_id": 1,
      "name": "Mike's Semi-Awesome Yard",
      "street_address": "124 Cook Street",
      "city": "Philadelphia",
      "state": "PA",
      "zipcode": "19125",
      "price": 10.50,
      "description": "This yard is cement",
      "payment": "venmo/paypal infomraiton?",
      "availability": "mornings",
      "photo_url_1": "https:picture1.org",
      "photo_url_2": "",
      "photo_url_3": "",
      "purposes": [1, 2, 3]
    }
  ```
  Response will be the same as the [Yard Details Response](#yard-details)

## Update a Yard
`POST /api/v1/yards/:yard_id`
  ```json
    {
      "host_id": 1,
      "name": "Mike's Semi-Awesome Yard",
      "street_address": "124 Cook Street",
      "city": "Philadelphia",
      "state": "PA",
      "zipcode": "19125",
      "price": 10.50,
      "description": "This yard is cement",
      "payment": "venmo/paypal infomraiton?",
      "availability": "mornings",
      "photo_url_1": "https:picture1.org",
      "photo_url_2": "",
      "photo_url_3": "",
      "purposes": [1, 2]
    }
  ```
  Response will be the same as the [Yard Details Response](#yard-details)

## Delete a Yard
`DELETE /api/v1/yards/:yard_id`
- Destroy a yard if the id matches
- Destroy any subsequent yard-purposes

## User Yards
`GET /api/v1/yards/host/yards?user_id=1`
  ```json
  {
    "data": [
      {
        "id": "1",
          "type": "yard",
          "attributes": {
            "host_id": "1",
            "name": "Mike's Awesome Yard",
            "street_address": "123 Baker Street",
            "city": "Philadelphia",
            "state": "PA",
            "zipcode": "19125",
            "price": 10.50,
            "description": "This yard is green and 1200 sf",
            "payment": "venmo/paypal infomraiton?",
            "availability": "weekends and weekdays after 5pm",
            "photo_url_1": "https:picture1.org",
            "photo_url_2": "",
            "photo_url_3": "",
            "purposes": {
              "data": [
                {
                  "id": "1",
                  "type": "purpose",
                  "attributes": {
                    "name": "Pet Rental",
                  }
                },
                {
                  "id": "2",
                  "type": "purpose",
                  "attributes": {
                    "name": "Party Rental",
                  }
                }
              ]
            }
          }
      },
      {
        "id": "2",
        "type": "yard",
          "attributes": {
            "host_id": "1",
            "name": "Bohem Garden",
            "street_address": "123 Bohem Street",
            "city": "Philadelphia",
            "state": "PA",
            "zipcode": "19125",
            "price": 20.50,
            "description": "This yard is a garden oasis to transport you out of the city",
            "payment": "venmo/paypal infomraiton?",
            "availability": "all day every day",
            "photo_url_1": "https:picture12.org",
            "photo_url_2": "",
            "photo_url_3": "",
            "purposes": {
              "data": [
                {
                  "id": "1",
                  "type": "purpose",
                  "attributes": {
                    "name": "Pet Rental",
                  }
                }
              ]
            }
          }
      },
      {
        "id": "3",
        "type": "yard",
          "attributes": {
            "host_id": "1",
            "name": "Rooftop Party",
            "street_address": "123 Market Street",
            "city": "Philadelphia",
            "state": "PA",
            "zipcode": "19125",
            "description": "The name says it all",
            "price": 15.50,
            "payment": "venmo/paypal infomraiton?",
            "availability": "please contact for availability",
            "photo_url_1": "https:picture31.org",
            "photo_url_2": "",
            "photo_url_3": "",
            "purposes": {
              "data": [
                {
                  "id": "1",
                  "type": "purpose",
                  "attributes": {
                    "name": "Pet Rental",
                  }
                }
              ]
            }
          }
      }
    ]
  }
  ```

## Yard Search
`GET /api/v1/yards?location=19125&purposes=pet+rental&pet+rental`
  ```json
  {
    "data": [
      {
        "id": "1",
          "type": "yard",
          "attributes": {
            "host_id": 1,
            "name": "Mike's Awesome Yard",
            "street_address": "123 Baker Street",
            "city": "Philadelphia",
            "state": "PA",
            "zipcode": "19125",
            "price": 10.50,
            "description": "This yard is green and 1200 sf",
            "payment": "venmo/paypal infomraiton?",
            "availability": "weekends and weekdays after 5pm",
            "photo_url_1": "https:picture1.org",
            "photo_url_2": "",
            "photo_url_3": "",
            "purposes": {
              "data": [
                {
                  "id": "1",
                  "type": "purpose",
                  "attributes": {
                    "name": "Pet Rental",
                  }
                },
                {
                  "id": "2",
                  "type": "purpose",
                  "attributes": {
                    "name": "Party Rental",
                  }
                }
              ]
            }
          }
      },
      {
        "id": "2",
        "type": "yard",
          "attributes": {
            "host_id": 2,
            "name": "Bohem Garden",
            "street_address": "123 Bohem Street",
            "city": "Philadelphia",
            "state": "PA",
            "zipcode": "19125",
            "price": 20.50,
            "description": "This yard is a garden oasis to transport you out of the city",
            "payment": "venmo/paypal infomraiton?",
            "availability": "all day every day",
            "photo_url_1": "https:picture12.org",
            "photo_url_2": "",
            "photo_url_3": "",
            "purposes": {
              "data": [
                {
                  "id": "1",
                  "type": "purpose",
                  "attributes": {
                    "name": "Pet Rental",
                  }
                }
              ]
            }
          }
      },
      {
        "id": "3",
        "type": "yard",
          "attributes": {
            "host_id": 3,
            "name": "Rooftop Party",
            "street_address": "123 Market Street",
            "city": "Philadelphia",
            "state": "PA",
            "zipcode": "19125",
            "description": "The name says it all",
            "price": 15.50,
            "payment": "venmo/paypal infomraiton?",
            "availability": "please contact for availability",
            "photo_url_1": "https:picture31.org",
            "photo_url_2": "",
            "photo_url_3": "",
            "purposes": {
              "data": [
                {
                  "id": "1",
                  "type": "purpose",
                  "attributes": {
                    "name": "Pet Rental",
                  }
                }
              ]
            }
          }
      }
    ]
  }
  ```

## Host Bookings By Status
`GET /api/v1/hosts/:host_id/bookings?status=approved`
  ```json
  {
    "data": [
      {
        "id": "1",
          "type": "booking",
          "attributes": {
            "status": "approved",
            "yard_id": "1",
            "booking_name": "Dog Play Date",
            "date": "2021-06-20",
            "time": "1800",
            "duration": 120,
            "description": "Renting a yard to run my pup and their best friend for 2 hours"
          }
      },
      {
        "id": "2",
        "type": "booking",
        "attributes": {
            "status": "approved",
            "yard_id": "1",
            "booking_name": "Picnic",
            "date": "2021-06-20",
            "time": "1500",
            "duration": 180,
            "description": "Renting for a picnic for Galentine's Day!"
          }
      },
      {
        "id": "3",
        "type": "booking",
        "attributes": {
            "status": "approved",
            "yard_id": "2",
            "booking_name": "Badmitton Game",
            "date": "2021-06-20",
            "time": "1430",
            "duration": 60,
            "description": "Renting the yard to play a championship game of badmitton"
          }
      }
    ]
  }
  ```

## Renter Bookings By Status
`GET /api/v1/renters/:renter_id/bookings?status=approved`
  ```json
  {
    "data": [
      {
        "id": "1",
          "type": "booking",
          "attributes": {
            "status": "approved",
            "yard_id": "1",
            "booking_name": "Dog Play Date",
            "date": "2021-06-20",
            "time": "1800",
            "duration": 120,
            "description": "Renting a yard to run my pup and their best friend for 2 hours"
          }
      },
      {
        "id": "2",
        "type": "booking",
        "attributes": {
            "status": "approved",
            "yard_id": "1",
            "booking_name": "Picnic",
            "date": "2021-06-20",
            "time": "1730",
            "duration": 180,
            "description": "Renting for a picnic for Galentine's Day!"
          }
      },
      {
        "id": "3",
        "type": "booking",
        "attributes": {
            "status": "approved",
            "yard_id": "2",
            "booking_name": "Badmitton Game",
            "date": "2021-06-20",
            "time": "1800",
            "duration": 60,
            "description": "Renting the yard to play a championship game of badmitton"
          }
      }
    ]
  }
  ```

## Yard Bookings
`GET /api/v1/yards/:yard_id/bookings`
`GET /api/v1/yards/1/bookings`
  ```json
  {
    "data": [
      {
        "id": "1",
          "type": "booking",
          "attributes": {
            "status": "approved",
            "yard_id": 1,
            "booking_name": "Dog Play Date",
            "date": "2021-06-20",
            "time": "1800",
            "duration": 120,
            "description": "Renting a yard to run my pup and their best friend for 2 hours"
          }
      },
      {
        "id": "2",
        "type": "booking",
        "attributes": {
            "status": "approved",
            "yard_id": 1,
            "booking_name": "Picnic",
            "date": "2021-06-20",
            "time": "1800",
            "duration": 180,
            "description": "Renting for a picnic for Galentine's Day!"
          }
      },
      {
        "id": "3",
        "type": "booking",
        "attributes": {
            "status": "approved",
            "yard_id": 1,
            "booking_name": "Badmitton Game",
            "date": "2021-06-20",
            "time": "1800",
            "duration": 60,
            "description": "Renting the yard to play a championship game of badmitton"
          }
      }
    ]
  }
  ```

## Booking Details
`GET /api/v1/bookings/:booking_id`
  ```json
  {
      "data": {
        "id": "1",
        "type": "booking",
        "attributes": {
          "status": "approved",
          "yard_id": 1,
          "booking_name": "Dog Play Date",
          "date": "2021-06-20",
          "time": "1800",
          "duration": 120,
          "description": "Renting a yard to run my pup and their best friend for 2 hours"
        }
      }
    }
  ```

## Create a Booking
`POST /api/v1/bookings`
  ```json
  {
    "yard_id": 1,
    "booking_name": "Dog Party",
    "date": "08-15-21",
    "time": "1400",
    "duration": 120,
    "description": "Renting a yard to run my pup and their best friend for 2 hours"
  }
  ```

## Delete a Booking
`DELETE /api/v1/bookings/:booking_id`
- Destroy a booking if the id matches and it passes cancellation policy validation

## Sad Path Response (no data matches query)
  ```json
    {
      "data": {}
    }
  ```

## Edge Case Response (weird data)
  ```json
  {
    "error": "error message"
  }
  ```
