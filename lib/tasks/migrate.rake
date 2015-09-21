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
module FedoraMigrate::DatastreamVerification
  def xhas_matching_checksums?
    source_checksum = datastream.checksum || checksum(datastream.content)
    puts "source: #{datastream.checksum} target: #{target_checksum} fallback: #{!!datastream.checksum}"
    puts "target digest: #{target.digest.inspect}"
    source_checksum == target_checksum
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