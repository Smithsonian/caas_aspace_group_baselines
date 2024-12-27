class Repository
  # SI over-ride to ensure new repos are created with the set of permissions we explicitly want
  def after_create
    if self.repo_code == Repository.GLOBAL
      # No need for standard groups on this one.
      return
    end

    standard_groups = [{
                         :group_code => "repository-managers",
                         :description => I18n.t("group.default_group_names.repository_managers", :repo_code => repo_code),
                         :grants_permissions => ["manage_repository", "update_location_record", "update_subject_record",
                                                 "update_agent_record", "update_accession_record", "update_resource_record",
                                                 "update_digital_object_record", "update_event_record", "delete_event_record", "update_container_record",
                                                 "update_container_profile_record", "update_location_profile_record",
                                                 "view_repository", "delete_archival_record", "suppress_archival_record",
                                                 "manage_subject_record", "manage_agent_record", "view_agent_contact_record", "manage_vocabulary_record",
                                                 "manage_rde_templates", "manage_container_record", "manage_container_profile_record",
                                                 "manage_location_profile_record", "import_records", "cancel_job",
                                                 "update_assessment_record", "delete_assessment_record", "manage_assessment_attributes",
                                                 "update_enumeration_record", "manage_enumeration_record",
                                                 "show_full_agents", "manage_custom_report_templates"]
                       },
                       {
                         :group_code => "repository-archivists",
                         :description => I18n.t("group.default_group_names.repository_archivists", :repo_code => repo_code),
                         :grants_permissions => ["update_subject_record", "update_agent_record", "update_accession_record",
                                                 "update_resource_record", "update_digital_object_record", "update_event_record",
                                                 "update_container_record", "update_container_profile_record",
                                                 "update_location_profile_record", "view_repository", "manage_subject_record",
                                                 "manage_agent_record", "view_agent_contact_record", "manage_vocabulary_record", "manage_container_record",
                                                 "manage_container_profile_record", "manage_location_profile_record", "import_records",
                                                 "update_assessment_record", "delete_assessment_record", "create_job", "cancel_job",
                                                 "update_enumeration_record", "manage_enumeration_record",
                                                 "show_full_agents", "manage_custom_report_templates"]
                       },
                       {
                         :group_code => "repository-project-managers",
                         :description => I18n.t("group.default_group_names.project_managers", :repo_code => repo_code),
                         :grants_permissions => ["view_repository", "update_accession_record", "update_resource_record",
                                                 "update_digital_object_record", "update_event_record", "delete_event_record", "update_subject_record",
                                                 "update_agent_record", "update_container_record",
                                                 "update_container_profile_record", "update_location_profile_record",
                                                 "delete_archival_record", "suppress_archival_record",
                                                 "manage_subject_record", "manage_agent_record", "view_agent_contact_record", "manage_vocabulary_record",
                                                 "manage_container_record", "manage_container_profile_record",
                                                 "manage_location_profile_record", "import_records", 'merge_agents_and_subjects',
                                                 "update_assessment_record", "delete_assessment_record", "update_enumeration_record",
                                                 "manage_enumeration_record"]
                       },
                       {
                         :group_code => "repository-advanced-data-entry",
                         :description => I18n.t("group.default_group_names.advanced_data_entry", :repo_code => repo_code),
                         :grants_permissions => ["view_repository", "update_accession_record", "update_resource_record",
                                                 "update_digital_object_record", "update_event_record", "update_subject_record",
                                                 "update_agent_record", "update_container_record",
                                                 "update_container_profile_record", "update_location_profile_record",
                                                 "manage_subject_record", "manage_agent_record",
                                                 "manage_vocabulary_record", "manage_container_record",
                                                 "manage_container_profile_record", "manage_location_profile_record",
                                                 "import_records", "update_assessment_record", "delete_assessment_record",
                                                 "update_enumeration_record", "manage_enumeration_record"]
                       },
                       {
                         :group_code => "repository-basic-data-entry",
                         :description => I18n.t("group.default_group_names.basic_data_entry", :repo_code => repo_code),
                         :grants_permissions => ["view_repository", "update_accession_record", "update_resource_record",
                                                 "update_digital_object_record", "create_job"]
                       },
                       {
                         :group_code => "repository-viewers",
                         :description => I18n.t("group.default_group_names.repository_viewers", :repo_code => repo_code),
                         :grants_permissions => ["view_repository", "create_job"]
                       }]

    RequestContext.open(:repo_id => self.id) do
      standard_groups.each do |group_data|
        Group.create_from_json(JSONModel(:group).from_hash(group_data),
                               :repo_id => self.id)
      end
    end

    Notifications.notify("REPOSITORY_CHANGED")
  end
end
