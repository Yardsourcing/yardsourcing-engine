Booking.destroy_all
Purpose.destroy_all
YardPurpose.destroy_all
Yard.destroy_all

yard1 = Yard.create(host_id: 1,
                    name: 'Ultimate Party Yard',
                    street_address: '123 4th St',
                    city: 'Denver',
                    state: 'CO',
                    zipcode: '80202',
                    price: '20.00',
                    description: 'This yard is equiped with a firepit, a pool, and a pool house to accommodate all your party needs.',
                    availability: 'Available on weekends in May',
                    payment: 'Venmo',
                    photo_url_1: 'https://i.pinimg.com/originals/33/68/61/33686194d9ec6fff887d4a77b33fab26.jpg',
                    photo_url_2: '',
                    photo_url_3: '')
yard2 = Yard.create(host_id: 1,
                    name: 'Large Yard for any Hobby',
                    street_address: '20 Main St',
                    city: 'Denver',
                    state: 'CO',
                    zipcode: '80202',
                    price: 25.50,
                    description: 'A large backyard close to the city. Equiped with a barbeque.',
                    availability: 'NEW - Most days are available',
                    payment: 'Venmo,Paypal',
                    photo_url_1: '',
                    photo_url_2: '',
                    photo_url_3: '')
yard3 = Yard.create(host_id: 2,
                    name: 'Multipurpose Yard',
                    street_address: '320 Seattle Lane',
                    city: 'Denver',
                    state: 'CO',
                    zipcode: '80202',
                    price: 15.50,
                    description: 'Fenced in yard for privacy.',
                    availability: 'Available on Monday, Wednesday, Friday, and Saturdays',
                    payment: 'Paypal',
                    photo_url_1: '',
                    photo_url_2: '',
                    photo_url_3: '')
yard4 = Yard.create(host_id: 3,
                    name: "A Pet's Dream",
                    street_address: '4855 Frisco Lane',
                    city: 'Conway',
                    state: 'AR',
                    zipcode: '72034',
                    price: 10.50,
                    description: 'This is the perfect yard for your pet to play! Fenced in yard in a quiet neighborhood',
                    availability: 'Available on any weekday',
                    payment: 'Venmo',
                    photo_url_1:'https://thedesignofthingsdotcom.files.wordpress.com/2016/03/fenced-private-backyard.jpg',
                    photo_url_2: '',
                    photo_url_3: '')

yard5 = Yard.create(host_id: 3,
                    name: 'Country ',
                    street_address: '10 Highway 64',
                    city: 'Conway',
                    state: 'AR',
                    zipcode: '72034',
                    price: 15.00,
                    description: 'This yard is on a huge piece of land in the middle of nowhere so there are endless possiblities of events to host for our guests!',
                    availability: 'Weekends only',
                    payment: 'Venmo, Cashapp',
                    photo_url_1: 'https://image.shutterstock.com/image-photo/spacious-yard-home-garden-swing-260nw-1609425607.jpg',
                    photo_url_2: '',
                    photo_url_3: '')


purpose1 = Purpose.create(id: 1, name: 'pet rental')
purpose2 = Purpose.create(id: 2, name: 'party rental')
purpose3 = Purpose.create(id: 3, name: 'hobby rental')

YardPurpose.create(yard_id: yard1.id, purpose_id: purpose1.id)
YardPurpose.create(yard_id: yard1.id, purpose_id: purpose2.id)
YardPurpose.create(yard_id: yard2.id, purpose_id: purpose3.id)
YardPurpose.create(yard_id: yard3.id, purpose_id: purpose3.id)
YardPurpose.create(yard_id: yard3.id, purpose_id: purpose2.id)
YardPurpose.create(yard_id: yard4.id, purpose_id: purpose1.id)
YardPurpose.create(yard_id: yard5.id, purpose_id: purpose1.id)
YardPurpose.create(yard_id: yard5.id, purpose_id: purpose2.id)
YardPurpose.create(yard_id: yard5.id, purpose_id: purpose3.id)


yard1.bookings.create(renter_id: 1,
                      status: :approved,
                      booking_name: "Pet Birthday Party",
                      date: Date.new(2021,04,25),
                      time: Time.new(2021, 04, 25, 14).strftime("%H:%M"),
                      duration: 3,
                      description: 'Throwing a bday party for my pet.')
yard1.bookings.create(renter_id: 2,
                      status: :pending,
                      booking_name: "Pet Extravaganza",
                      date: Date.new(2021,04,17),
                      time: Time.new(2021,04,17,16).strftime("%H:%M"),
                      duration: 2,
                      description: 'My friends and I want a space all our pets can play.')
yard1.bookings.create(renter_id: 3,
                      status: :pending,
                      booking_name: "3 Year Old Birthday Party",
                      date: Date.new(2021,04,30),
                      time: Time.new(2021,04,30,10).strftime("%H:%M"),
                      duration: 4,
                      description: 'Needs a space for my 3 year olds birthday party')
yard2.bookings.create(renter_id: 4,
                      status: :approved,
                      booking_name: "Barbeque with Friends",
                      date: Date.new(2021,04,25),
                      time: Time.new(2021,04,25,18).strftime("%H:%M"),
                      duration: 2,
                      description: 'Wanting to grill out with my friends.')
yard3.bookings.create(renter_id: 1,
                      status: :pending,
                      booking_name: 'Spotlight Tag',
                      date: Date.new(2021,05,05),
                      time: Time.new(2021,05,05,21).strftime("%H:%M"),
                      duration: 2,
                      description: 'Wanting to have a 50 person game of spotlight tag.')
yard4.bookings.create(renter_id: 2,
                      status: :pending,
                      booking_name: 'Pet Play Date',
                      date: Date.new(2021,04,30),
                      time: Time.new(2021,04,30,9,30).strftime("%H:%M"),
                      duration: 1,
                      description: 'My dog needs to run!')
yard5.bookings.create(renter_id: 3,
                      status: :rejected,
                      booking_name: 'Country Throw Down',
                      date: Date.new(2021,04,25),
                      time: Time.new(2021,04,25,20).strftime("%H:%M"),
                      duration: 8,
                      description: 'Trying to throw a rager with my friends.')
