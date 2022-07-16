const { json } = require("express");
const express = require("express");
const adminRouter = express.Router();
const admin = require("../middlewares/admin");
const Product = require("../models/product");
//Add a Product

adminRouter.post("/admin/add-product", admin, async (req, res) => {
  try {
    const { name, description, images, quantity, price, category } = req.body;
    let product = new Product({
      name,
      description,
      images,
      quantity,
      price,
      category,
    });
    await product.save();
    const products = await Product.find({});
    res.json(products);
    console.log(products);
  } catch (e) {
    res.status(500).json({ error: e.message });
    console.log(e);
  }
});

//Get all Products
adminRouter.get("/admin/get-product", admin, async (req, res) => {
  try {
    const products = await Product.find({});
    console.log(products);
    res.json(products);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

//Get all Products
adminRouter.post("/admin/delete-product", admin, async (req, res) => {
  try {
    const { id } = req.body;
    let product = await Product.findByIdAndDelete(id);
    res.json(product);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = adminRouter;
 