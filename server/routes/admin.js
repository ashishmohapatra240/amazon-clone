const { json } = require("express");
const express = require("express");
const adminRouter = express.Router();
const admin = require("../middlewares/admin");
const Product = require("../models/product");
//Add a Product

adminRouter.post("/admin/add-product", admin, async (req, res) => {
  const { name, description, images, quantity, price, category } = req.body;
  let product = new Product({
    name,
    description,
    images,
    quantity,
    price,
    category,
  });
  try {
    const products = await Product.find({});
    res.json(products);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

//Get all Products
adminRouter.get("/admin/get-product", admin, async (req, res) => {
  try {
    product = await product.save();
    res.json(product);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = adminRouter;
