FactoryBot.define do
  factory :purpose do
    sequence :name  do |n|
      "Purpose #{n + 1}"
    end
  end
end
