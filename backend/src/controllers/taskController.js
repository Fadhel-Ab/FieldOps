const taskRepository = require("../repositories/taskRepository");

function getTasks(req, res) {
  const userId = req.user.id;

  const tasks = taskRepository.getTasksByUserId(userId);

  res.json(tasks);
}
async function updateTask(req, res) {
  try {
    const id = Number(req.params.id);
    const { status, latitude, longitude, notes } = req.body;

    const updates = {};

    if (status !== undefined) updates.status = status;
    if (latitude !== undefined) updates.latitude = parseFloat(latitude);
    if (longitude !== undefined) updates.longitude = parseFloat(longitude);
    if (notes !== undefined) updates.notes = notes;

    if (req.file) {
      updates.imageBuffer = req.file.buffer;
      updates.mimetype = req.file.mimetype;
    }

    const updatedTask = await taskRepository.updateTask(id, updates);
    console.log(req.body);
    console.log(req.file);
    res.json({
      message: "Task updated successfully",
      task: updatedTask,
    });
  } catch (error) {
    return res.status(404).json({
      message: "Task not found",
    });
  }
}
module.exports = {
  getTasks,
  updateTask,
};
