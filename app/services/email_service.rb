class EmailService

  def self.new_booking(booking_id)
    booking = Booking.find(booking_id)
    to = booking.yard.email
    from = booking.renter_email
    subject = "New booking request for #{booking.yard.name}"
    content = "Someone wants to rent your Yard!\nDetails:\n(booking details)"

    send_email(to, from, subject, content)
  end

  def self.approved_booking(booking_id)
    booking = Booking.find(booking_id)
    to = booking.renter_email
    from = booking.yard.email
    subject = "You're request tor rent #{booking.yard.name}, has been approved!"
    content = "your request has been approved!\nDetails:\n(booking details)"

    send_email(to, from, subject, content)
  end

  def self.rejected_booking(booking_id)
    booking = Booking.find(booking_id)
    to = booking.renter_email
    from = booking.yard.email
    subject = "You're request tor rent #{booking.yard.name}, has been rejected."
    content = "your request has been rejected!\nDetails:\n(booking details)"

    send_email(to, from, subject, content)
  end

  def self.send_email(to, from, subject, content)
    response = connection.post('/api/v1/mail') do |req|
      req.headers["CONTENT_TYPE"] = "application/json"
      req.params = {to: to, from: from, subject: subject, content: content}
    end
  end

  def self.connection
    Faraday.new(url: "https://peaceful-bastion-57477.herokuapp.com")
  end
end
