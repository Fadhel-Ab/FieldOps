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
  },
  {
    id: 1,
    userId: 1,
    title: "Install something",
    description: "Install and test router",
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
  const taskIndex = tasks.find((task) => task.id === id);

  if (taskIndex === -1) {
    throw new Error("Task not found");
  }

const task = tasks[taskIndex];
  console.log("Before:", task);

  Object.keys(updates).forEach((key) => {
    if (updates[key] !== undefined) {
       // If handling the uploaded image file buffer
      if (key === 'imageBuffer' && updates.imageBuffer) {
        task.image = `data:${updates.mimetype};base64,${updates.imageBuffer.toString('base64')}`;
      } else if (key === 'mimetype') {
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
