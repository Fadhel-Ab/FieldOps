const tasks = [
  {
    id: 1,
    userId: 1,
    title: "Install network equipment",
    description: "Install and test router",
    status: "Pending",
    latitude: 26.2235,
    longitude: 50.5876,
    image: null,
  },
  {
    id: 2,
    userId: 1,
    title: "Check customer site",
    description: "Perform site inspection",
    status: "In Progress",
    latitude: 26.2235,
    longitude: 50.5876,
    image: null,
  },
  {
    id: 3,
    userId: 2,
    title: "Replace hardware",
    description: "Replace damaged equipment",
    status: "Pending",
    latitude: 26.2235,
    longitude: 50.5876,
    image: null,
  },
];

function getTasksByUserId(userId) {
  return tasks.filter((task) => task.userId === userId);
}

function updateTask(id, updates) {
    const task = tasks.find(task => task.id === id);

    if (!task) {
        return null;
    }

    Object.assign(task, updates);

    return task;
}

module.exports = {
    getTasksByUserId,
    updateTask
};

module.exports = {
  getTasksByUserId,
};
