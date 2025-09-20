# Supabase Integration Setup Guide

This guide will help you set up Supabase integration for your Neat Prompts application.

## Prerequisites

1. A Supabase account (sign up at [supabase.com](https://supabase.com))
2. Node.js and npm installed
3. Your project dependencies installed

## Step 1: Create a Supabase Project

1. Go to [supabase.com](https://supabase.com) and sign in
2. Click "New Project"
3. Choose your organization
4. Enter a project name (e.g., "neat-prompts")
5. Enter a database password (save this securely)
6. Choose a region close to your users
7. Click "Create new project"

## Step 2: Get Your Project Credentials

1. In your Supabase project dashboard, go to Settings → API
2. Copy the following values:
   - **Project URL** (e.g., `https://your-project-id.supabase.co`)
   - **anon/public key** (starts with `eyJ...`)

## Step 3: Set Up Environment Variables

1. Create a `.env` file in your project root (if it doesn't exist)
2. Add your Supabase credentials:

```env
VITE_SUPABASE_URL=https://your-project-id.supabase.co
VITE_SUPABASE_ANON_KEY=your_anon_key_here
```

**Important:** Never commit your `.env` file to version control!

## Step 4: Set Up Database Schema

1. In your Supabase dashboard, go to SQL Editor
2. Copy the contents of `supabase-schema.sql` from this project
3. Paste it into the SQL editor and click "Run"
4. This will create all necessary tables and sample data

## Step 5: Test the Integration

1. Start your development server: `npm run dev`
2. The app should now connect to Supabase
3. Check the browser console for any connection errors

## Database Schema

The following tables are created:

- **prompts**: Stores prompt data with title, content, description, etc.
- **categories**: Prompt categories with names and colors
- **tags**: Prompt tags with names and colors
- **prompt_tags**: Junction table for many-to-many relationships

## Features

- ✅ Full CRUD operations for prompts
- ✅ Category and tag management
- ✅ Search functionality
- ✅ Favorites system
- ✅ Automatic timestamps
- ✅ UUID primary keys
- ✅ Proper foreign key relationships

## Troubleshooting

### Common Issues

1. **"Missing Supabase environment variables"**
   - Check that your `.env` file exists and has the correct variable names
   - Ensure the file is in the project root

2. **"Failed to fetch prompts"**
   - Verify your Supabase URL and key are correct
   - Check that the database schema has been created
   - Look for CORS errors in the browser console

3. **"Table doesn't exist"**
   - Run the SQL schema file in Supabase SQL Editor
   - Check that all tables were created successfully

### Getting Help

- Check the [Supabase documentation](https://supabase.com/docs)
- Review the browser console for error messages
- Verify your environment variables are loaded correctly

## Migration from Other Databases

If you're migrating from another database:

1. Export your existing data
2. Transform the data to match the new schema
3. Import the data using Supabase's data import tools
4. Update your application code to use the new Supabase service

## Next Steps

- Implement user authentication with Supabase Auth
- Add Row Level Security (RLS) policies
- Set up real-time subscriptions for collaborative features
- Implement backup and restore functionality
