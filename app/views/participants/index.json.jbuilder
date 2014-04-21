json.array!(@participants) do |participant|
  json.extract! participant, :id, :first_name, :middle_name, :last_name, :library_card, :email, :zip_code, :home_library, :school, :grade, :age, :club
  json.url participant_url(participant, format: :json)
end
