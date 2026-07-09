const users = [
    {
        id: 1,
        email: "employee@test.com",
        password: "123456"
    }
];

function findUserByEmail(email) {
    return users.find(user => user.email === email);
}

module.exports = {
    findUserByEmail
};