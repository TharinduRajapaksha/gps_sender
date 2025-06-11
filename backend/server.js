const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const cors = require('cors');

// Replace with your MongoDB connection string
//const MONGO_URI = "mongodb+srv://<username>:<password>@cluster.mongodb.net/gps?retryWrites=true&w=majority";

require('dotenv').config();
const MONGO_URI = process.env.MONGO_URI;


mongoose.connect(MONGO_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
}).then(() => console.log("MongoDB connected"))
  .catch(err => console.log("Mongo Error:", err));

const LocationSchema = new mongoose.Schema({
  latitude: Number,
  longitude: Number,
  timestamp: String
});
const Location = mongoose.model('Location', LocationSchema);

const app = express();
app.use(cors());
app.use(bodyParser.json());

app.post('/location', async (req, res) => {
  try {
    const loc = new Location(req.body);
    await loc.save();
    res.status(200).json({ message: 'Location saved' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to save location' });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
