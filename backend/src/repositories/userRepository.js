const users = [
  {
    id: 1,
    email: "employee@test.com",
    username: "Ahmed",
    password: "123456",
  },
  {
    id: 2,
    email: "employee@testing.com",
    username: "Ali",
    password: "123456",
  },
];

function findUserByEmail(email) {
  return users.find((user) => user.email === email);
}

module.exports = {
  findUserByEmail,
};
