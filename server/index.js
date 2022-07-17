const express = require("express");
const mongoose = require("mongoose");

const authRouter = require("./routes/auth.js");
const adminRouter = require("./routes/admin.js");
const productRouter = require("./routes/product.js");


//INIT
const PORT = process.env.PORT || 3000;
const app = express();
const DB =
  "mongodb+srv://ashishmohapatra240:ashishmohapatra240@cluster0.svs4i.mongodb.net/?retryWrites=true&w=majority";

//Middleware
app.use(express.json());
app.use(authRouter);
app.use(adminRouter);
app.use(productRouter);


//Connections
mongoose
  .connect(DB)
  .then(() => {
    console.log("Connection Successful");
  })
  .catch((e) => {
    console.log(e);
  });

app.listen(PORT, "0.0.0.0", () => {
  console.log(`connected at PORT ${PORT}`);
});
