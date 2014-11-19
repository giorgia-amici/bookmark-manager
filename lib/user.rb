class User
	include DataMapper::Resource

	property :email, String, :unique => true, :message => "This email is already taken"


end