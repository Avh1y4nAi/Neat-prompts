-- Supabase Database Schema for Neat Prompts

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create categories table
CREATE TABLE IF NOT EXISTS categories (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    color VARCHAR(7), -- Hex color code
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    user_id UUID -- For future user authentication
);

-- Create tags table
CREATE TABLE IF NOT EXISTS tags (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    color VARCHAR(7), -- Hex color code
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    user_id UUID -- For future user authentication
);

-- Create prompts table
CREATE TABLE IF NOT EXISTS prompts (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    title VARCHAR(500) NOT NULL,
    content TEXT NOT NULL,
    description TEXT,
    category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
    is_favorite BOOLEAN DEFAULT FALSE,
    usage_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    user_id UUID -- For future user authentication
);

-- Create prompt_tags junction table for many-to-many relationship
CREATE TABLE IF NOT EXISTS prompt_tags (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    prompt_id UUID REFERENCES prompts(id) ON DELETE CASCADE,
    tag_id UUID REFERENCES tags(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(prompt_id, tag_id)
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_prompts_category_id ON prompts(category_id);
CREATE INDEX IF NOT EXISTS idx_prompts_created_at ON prompts(created_at);
CREATE INDEX IF NOT EXISTS idx_prompts_updated_at ON prompts(updated_at);
CREATE INDEX IF NOT EXISTS idx_prompts_user_id ON prompts(user_id);
CREATE INDEX IF NOT EXISTS idx_prompt_tags_prompt_id ON prompt_tags(prompt_id);
CREATE INDEX IF NOT EXISTS idx_prompt_tags_tag_id ON prompt_tags(tag_id);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger to automatically update updated_at
CREATE TRIGGER update_prompts_updated_at 
    BEFORE UPDATE ON prompts 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- Insert sample data
INSERT INTO categories (name, description, color) VALUES
    ('Writing', 'Creative writing and content creation', '#3B82F6'),
    ('Development', 'Programming and technical content', '#10B981'),
    ('Marketing', 'Marketing and sales content', '#F59E0B'),
    ('Analysis', 'Data analysis and insights', '#8B5CF6'),
    ('Research', 'Research and academic content', '#EF4444')
ON CONFLICT (name) DO NOTHING;

INSERT INTO tags (name, color) VALUES
    ('creative', '#3B82F6'),
    ('storytelling', '#8B5CF6'),
    ('characters', '#EC4899'),
    ('code', '#10B981'),
    ('review', '#F59E0B'),
    ('optimization', '#059669'),
    ('copywriting', '#DC2626'),
    ('conversion', '#EA580C'),
    ('sales', '#BE185D')
ON CONFLICT (name) DO NOTHING;

-- Insert sample prompts
INSERT INTO prompts (title, content, description, category_id, is_favorite, usage_count) VALUES
    (
        'Creative Writing Assistant',
        'You are a creative writing assistant. Help me develop compelling characters, engaging plots, and vivid descriptions for my story. Focus on show-don''t-tell techniques and create immersive narratives that captivate readers.',
        'AI assistant for creative writing and storytelling',
        (SELECT id FROM categories WHERE name = 'Writing'),
        TRUE,
        15
    ),
    (
        'Code Review Expert',
        'Review my code for best practices, potential bugs, security vulnerabilities, and performance optimizations. Provide specific suggestions for improvement and explain the reasoning behind each recommendation.',
        'Expert code review and optimization guidance',
        (SELECT id FROM categories WHERE name = 'Development'),
        FALSE,
        8
    ),
    (
        'Marketing Copy Generator',
        'Create compelling marketing copy that converts. Focus on benefits over features, use emotional triggers, and include clear calls-to-action. Adapt the tone for the target audience and platform.',
        'Generate high-converting marketing copy',
        (SELECT id FROM categories WHERE name = 'Marketing'),
        TRUE,
        12
    )
ON CONFLICT DO NOTHING;

-- Insert prompt-tag relationships
INSERT INTO prompt_tags (prompt_id, tag_id) VALUES
    ((SELECT id FROM prompts WHERE title = 'Creative Writing Assistant'), (SELECT id FROM tags WHERE name = 'creative')),
    ((SELECT id FROM prompts WHERE title = 'Creative Writing Assistant'), (SELECT id FROM tags WHERE name = 'storytelling')),
    ((SELECT id FROM prompts WHERE title = 'Creative Writing Assistant'), (SELECT id FROM tags WHERE name = 'characters')),
    ((SELECT id FROM prompts WHERE title = 'Code Review Expert'), (SELECT id FROM tags WHERE name = 'code')),
    ((SELECT id FROM prompts WHERE title = 'Code Review Expert'), (SELECT id FROM tags WHERE name = 'review')),
    ((SELECT id FROM prompts WHERE title = 'Code Review Expert'), (SELECT id FROM tags WHERE name = 'optimization')),
    ((SELECT id FROM prompts WHERE title = 'Marketing Copy Generator'), (SELECT id FROM tags WHERE name = 'copywriting')),
    ((SELECT id FROM prompts WHERE title = 'Marketing Copy Generator'), (SELECT id FROM tags WHERE name = 'conversion')),
    ((SELECT id FROM prompts WHERE title = 'Marketing Copy Generator'), (SELECT id FROM tags WHERE name = 'sales'))
ON CONFLICT DO NOTHING;
