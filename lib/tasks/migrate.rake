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

ActiveFedora::File.class_eval do
  def digest
    response = metadata.ldp_source.graph.query(predicate: RDF::Vocab::PREMIS.hasMessageDigest)
    # fallback on old predicate for checksum
    response = metadata.ldp_source.graph.query(predicate: RDF::Vocab::Fcrepo4.digest) if response.empty?
    response.map(&:object)
  end
end
FedoraMigrate::RelsExtDatastreamMover.class_eval do
  def migrate_object(fc3_uri)
    if (fc3_uri.to_s =~ /^info:fedora\/.+:.+/)
      RDF::URI.new(ActiveFedora::Base.id_to_uri(id_component(fc3_uri)))
    else
      RDF::URI.new(fc3_uri)
    end
  end
  def has_missing_object?(statement)
    return false unless (statement.object.to_s =~ /^info:fedora\/.+:.+/)
    return false if ActiveFedora::Base.exists?(id_component(statement.object))
    report << "could not migrate relationship #{statement.predicate} because #{statement.object} doesn't exist in Fedora 4"
    true
  end
end
desc "Delete all the content in Fedora 4"
task clean: :environment do
  ActiveFedora::Cleaner.clean!
end
desc "Migrate all my objects"
task migrate: :environment do
  Work.name
  GenericFile.name
  Collection.name
  AdministrativeSet.name
  hyconn = FedoraMigrate.migrate_repository(namespace: "hyconn",options:{})

  archives = FedoraMigrate.migrate_repository(namespace: "archives",options:{})
  report = FedoraMigrate::MigrationReport.new
  report.results.merge! hyconn.report.results
  report.results.merge! archives.report.results
  report.report_failures STDOUT
  report.save
end