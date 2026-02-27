const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.incrementProductView = functions.https.onCall(async (data, context) => {
  // 🔐 فقط کاربران لاگین‌شده
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "User must be authenticated"
    );
  }

  const productId = data.productId;

  if (!productId) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "productId is required"
    );
  }

  const productRef = admin.firestore().collection("products").doc(productId);

  // Atomic increment
  await productRef.update({
    viewCount: admin.firestore.FieldValue.increment(1),
  });

  return { success: true };
});
