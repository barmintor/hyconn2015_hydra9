module FedoraMigrate::Hooks

  # @source is a Rubydora object
  # @target is a Hydra 9 modeled object

  # Called from FedoraMigrate::ObjectMover
  def before_object_migration
    # additional actions as needed
  end

  # Called from FedoraMigrate::ObjectMover
  def after_object_migration
    # additional actions as needed
  end

  # Called from FedoraMigrate::RDFDatastreamMover
  def before_rdf_datastream_migration
    # additional actions as needed
  end

  # Called from FedoraMigrate::RDFDatastreamMover
  def after_rdf_datastream_migration
    # additional actions as needed
  end

  # Called from FedoraMigrate::DatastreamMover
  def before_datastream_migration
    # additional actions as needed
  end

  # Called from FedoraMigrate::DatastreamMover
  def after_datastream_migration
    # additional actions as needed
  end

end

desc "Delete all the content in Fedora 4"
task clean: :environment do
  ActiveFedora::Cleaner.clean!
end
desc "Migrate all my objects"
task migrate: :environment do
  hyconn = FedoraMigrate.migrate_repository(namespace: "hyconn",options:{})

  archives = FedoraMigrate.migrate_repository(namespace: "archives",options:{})
  report = FedoraMigrate::MigrationReport.new
  report.results.merge! hyconn.report.results
  report.results.merge! archives.report.results
  report.report_failures STDOUT
  report.save
end