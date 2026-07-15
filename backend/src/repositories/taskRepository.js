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
    notes: null,
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
    notes: null,
  },
  {
    id: 3,
    userId: 1,
    title: "Install Alarm System",
    description: "Install and test router",
    status: "In Progress",
    latitude: 26.2235,
    longitude: 50.5876,
    image: null,
    notes: null,
  },
  {
    id: 4,
    userId: 2,
    title: "Replace hardware",
    description: "Replace damaged equipment",
    status: "Pending",
    latitude: 26.2235,
    longitude: 50.5876,
    image: null,
    notes: null,
  },
  {
    id: 5,
    userId: 1,
    title: "Fix network cable",
    description: "Replace damaged Cat6 cable in server room",
    status: "Pending",
    latitude: 26.2167,
    longitude: 50.555,
    image: null,
    notes: null,
  },
  {
    id: 6,
    userId: 1,
    title: "Configure switch",
    description: "Set up VLANs on the core switch",
    status: "Completed",
    latitude: 26.2341,
    longitude: 50.5984,
    image: null,
    notes: null,
  },
];

function getTasksByUserId(userId) {
  return tasks.filter((task) => task.userId === userId);
}

function updateTask(id, updates) {
  const taskIndex = tasks.findIndex((task) => task.id === id);

  if (taskIndex === -1) {
    throw new Error("Task not found");
  }

  const task = tasks[taskIndex];
  console.log("Before:", task);

  Object.keys(updates).forEach((key) => {
    if (updates[key] !== undefined) {
      // If handling the uploaded image file buffer
      if (key === "imageBuffer" && updates.imageBuffer) {
        task.image = updates.imageBuffer;
        task.mimetype = updates.mimetype;
        return;
      } else {
        task[key] = updates[key];
      }
    }
  });

  console.log("After:", task);

  return task;
}

module.exports = {
  getTasksByUserId,
  updateTask,
};
