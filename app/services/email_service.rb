class EmailService

  def self.new_booking(booking_id)

  end

  def self.approved_booking(booking_id)

  end

  def self.rejected_booking(booking_id)

  end

  def self.send_email(to, from, subject, content)
    response = connection.post('/api/v1/mail') do |req|
      req.headers["CONTENT_TYPE"] = "application/json"
      req.params = {to: to, from: from, subject: subject, content: content}
    end

    return true if response.status == 202
    false
  end

  def self.connection
    Faraday.new(url: "https://peaceful-bastion-57477.herokuapp.com")
  end
end
