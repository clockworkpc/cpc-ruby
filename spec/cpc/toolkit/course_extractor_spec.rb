# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cpc::Toolkit::CourseExtractor do
  let(:course_path) { 'spec/fixtures/course_extractor/rails_course.html' }

  let(:titles_ary) do
    ['Welcome', 'How to use the exercise files', 'Ruby on Rails introduction', 'Understanding MVC architecture', 'Create a project', 'File structure of a project', 'Configure a project', 'Access a project', 'Generate a controller and view', 'Server request handling', 'Routes', 'Experiment on your own', 'Render a template', 'Redirect actions', 'View templates', 'Instance variables', 'Links', 'URL parameters', 'Introduction to databases', 'Create a database', 'Migrations', 'Generate migrations', 'Generate models', 'Run migrations', 'Migration methods', 'Solve migration problems', 'Challenge: Migrations for the CMS', 'Solution: Migrations for the CMS', 'ActiveRecord and ActiveRelation', 'Model naming', 'Model attributes', 'The Rails console', 'Create records', 'Update records', 'Delete records', 'Find records', 'Query methods: Conditions', 'Query methods: Order, limit,  and offset', 'Named scopes', 'Relationship types', 'One-to-one associations', 'One-to-many associations', 'belongs_to presence validation', 'Many-to-many associations: Simple', 'Many-to-many associations: Rich', 'Traverse a rich association', 'CRUD', 'REST', 'Resourceful routes', 'Resourceful URL helpers', 'Read action: Index', 'Read action: Show', 'Form basics', 'Create action: New', 'Create action: Create', 'Strong parameters', 'Update actions: Edit/update', 'Delete actions: Delete/destroy', 'Flash hash', 'Challenge: Pages and sections CRUD', 'Solution: Pages and sections CRUD', 'Layouts', 'Partial templates', 'Text helpers', 'Number helpers', 'Date and time helpers', 'Custom helpers', 'Sanitization helpers', 'Asset pipeline', 'Stylesheets', 'JavaScript', 'JavaScript tag and sanitizing', 'Images', 'Form helpers', 'Form options helpers', 'Date and time form helpers', 'Form errors', '(In progress)', 'Prevent cross-site request forgery', 'Validation methods', 'Write validations', 'Validates method', 'Custom validations', 'Cookies', 'Sessions', 'Controller filters', 'Logging', 'Authentication introduction', 'Secure passwords', 'Create a controller for access', 'Login and logout', 'Restrict access', 'Challenge: AdminUser CRUD', 'Solution: AdminUser CRUD', 'Public area', 'Public area navigation', 'Nesting pages in subjects', 'Nesting sections in pages', 'Adding RubyGems: acts_as_list', 'Finishing touches', 'Next steps']
  end

  context 'html_div' do
    it 'should return lesson title', offline: true do
      subject = Cpc::Toolkit::CourseExtractor.new(course_path)
      titles = subject.lesson_titles
      titles.each { |lt| puts lt }
      Clipboard.copy(titles)
      expect(titles).to eq(titles_ary)
    end
  end
end
