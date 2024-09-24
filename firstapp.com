const ItemSchema = new mongoose.Schema({
    name: String,
    price: Number
});

const Item = mongoose.model('Item', ItemSchema);

// Routes
app.get('/', (req, res) => {
    res.send('Hello from Dockerized Node.js App with MongoDB');
});

// POST route to create a new item
app.post('/items', async (req, res) => {
    const item = new Item({
        name: req.body.name,
        price: req.body.price
    });
    await item.save();
    res.json(item);
});

// GET route to fetch all items
app.get('/items', async (req, res) => {
    const items = await Item.find();
    res.json(items);
});

const PORT = process.env.PORT || 3300;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});