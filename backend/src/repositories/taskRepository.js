const tasks = [
    {
        id: 1,
        userId: 1,
        title: "Install network equipment",
        description: "Install and test router",
        status: "Pending"
    },
    {
        id: 2,
        userId: 1,
        title: "Check customer site",
        description: "Perform site inspection",
        status: "In Progress"
    },
    {
        id: 3,
        userId: 2,
        title: "Replace hardware",
        description: "Replace damaged equipment",
        status: "Pending"
    }
];


function getTasksByUserId(userId) {

    return tasks.filter(
        task => task.userId === userId
    );

}


module.exports = {
    getTasksByUserId
};