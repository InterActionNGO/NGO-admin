class ChangesHistoryRecord < ActiveRecord::Base
  belongs_to :who, :class_name => 'User', :foreign_key => :user_id
  belongs_to :what, :polymorphic => true

  def self.from_organization(organization)
    joins(:who).where(:'users.organization_id' => organization.id)
  end

  def self.search(search_params)
    query = where('user_id IS NOT NULL AND what_id IS NOT NULL')
    query = query.where(:user_id => search_params.who)                                if search_params.who.present?
    query = query.where(:what_type => search_params.what_type)                        if search_params.what_type.present?
    query = query.where('changes_history_records.when > ?', search_params.when_start) if search_params.when_start.present?
    query = query.where('changes_history_records.when < ?', search_params.when_end)   if search_params.when_end.present?
    query = query.order('changes_history_records.when desc')
    query = query.all
    query
  end

  def self.in_last_24h
    where('changes_history_records.user_id <> ? AND changes_history_records.when > ?', User.admin.id, 1.day.ago)
  end

  def changes
    @changes ||= ActiveSupport::JSON.decode(how) if how.present?
  end

  def changes_count
    changes.keys.count rescue 0
  end

  def what_name
    what.name rescue ''
  end

  def who_email
    who.email rescue attributes['who_email']
  end

  def who_organization
    who.organization rescue Organization.find_by_name(attributes['who_organization']) rescue nil
  end

  def who_organization_name
    attributes['who_organization'] || 'Interaction'
  end

  def reviewed=(value)
    write_attribute('reviewed', value == 'true')
  end
end
