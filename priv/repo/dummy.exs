alias Uncanny.Repo
alias Uncanny.Identities.User

# Users
%User{}
|> User.changeset(%{
  name: "Admin",
  email: "sprevost@mirego.com",
  password: "testtest1234",
  confirm_password: "testtest1234"
})
|> Repo.insert!()
