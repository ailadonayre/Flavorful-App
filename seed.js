// Firestore Seeding Script
// Run this with: node seed.js

const admin = require('firebase-admin');
require('dotenv').config();

// Initialize Firebase Admin SDK
const serviceAccount = {
  type: "service_account",
  project_id: process.env.PROJECT_ID,
  private_key_id: process.env.PRIVATE_KEY_ID,
  private_key: process.env.PRIVATE_KEY.replace(/\\n/g, '\n'),
  client_email: process.env.CLIENT_EMAIL,
  client_id: process.env.CLIENT_ID,
  auth_uri: "https://accounts.google.com/o/oauth2/auth",
  token_uri: "https://oauth2.googleapis.com/token",
  auth_provider_x509_cert_url: "https://www.googleapis.com/oauth2/v1/certs",
  client_x509_cert_url: process.env.CLIENT_CERT_URL
};

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: process.env.PROJECT_ID
});

const db = admin.firestore();
const auth = admin.auth();

// Sample users data
const users = [
  {
    email: 'yushi@flavorful.com',
    password: 'yushi123',
    username: 'yushi',
    displayName: 'Yushi',
    role: 'user',
    isVerifiedChef: false
  },
  {
    email: 'chef.thalia@flavorful.com',
    password: 'thalia123',
    username: 'chef_thalia',
    displayName: 'Chef Thalia',
    role: 'chef',
    isVerifiedChef: true
  },
  {
    email: 'cook.tony@flavorful.com',
    password: 'tony123',
    username: 'cook_tony',
    displayName: 'Cook Tony',
    role: 'chef',
    isVerifiedChef: true
  },
  {
    email: 'baker.sarah@flavorful.com',
    password: 'sarah123',
    username: 'baker_sarah',
    displayName: 'Baker Sarah',
    role: 'chef',
    isVerifiedChef: true
  },
  {
    email: 'amateur.alex@flavorful.com',
    password: 'alex123',
    username: 'amateur_alex',
    displayName: 'Alex K.',
    role: 'user',
    isVerifiedChef: false
  }
];

async function seedUsers() {
  console.log('Starting Firestore seeding...\n');

  for (const userData of users) {
    try {
      // Create user in Firebase Auth
      console.log(`Creating user: ${userData.email}`);
      const userRecord = await auth.createUser({
        email: userData.email,
        password: userData.password,
        displayName: userData.displayName
      });

      console.log(`✓ Auth user created with UID: ${userRecord.uid}`);

      // Create user document in Firestore
      const firestoreData = {
        username: userData.username.toLowerCase(),
        displayName: userData.displayName,
        email: userData.email,
        role: userData.role,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        isVerifiedChef: userData.isVerifiedChef,
        photoUrl: null
      };

      await db.collection('users').doc(userRecord.uid).set(firestoreData);
      console.log(`✓ Firestore document created for ${userData.displayName}\n`);

    } catch (error) {
      if (error.code === 'auth/email-already-exists') {
        console.log(`⚠ User ${userData.email} already exists, skipping...\n`);
      } else {
        console.error(`✗ Error creating user ${userData.email}:`, error.message, '\n');
      }
    }
  }

  console.log('Seeding completed!');
  console.log('\nTest Credentials:');
  console.log('─────────────────────────────────────');
  users.forEach(user => {
    console.log(`Email: ${user.email}`);
    console.log(`Password: ${user.password}`);
    console.log(`Role: ${user.role}`);
    console.log('─────────────────────────────────────');
  });
}

// Run the seeding function
seedUsers()
  .then(() => {
    console.log('\n✓ All done!');
    process.exit(0);
  })
  .catch((error) => {
    console.error('✗ Seeding failed:', error);
    process.exit(1);
  });