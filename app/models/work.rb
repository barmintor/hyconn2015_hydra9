require 'hydra/pcdm/vocab/pcdm_terms'
class Work < ActiveFedora::Base
  has_and_belongs_to_many :members, class_name: 'ActiveFedora::Base',
    predicate: Hydra::PCDM::Vocab::PCDMTerms['hasMember'], inverse_of: Hydra::PCDM::Vocab::PCDMTerms['memberOf']
  has_and_belongs_to_many :collectors, class_name: 'ActiveFedora::Base',
    predicate: Hydra::PCDM::Vocab::PCDMTerms['memberOf'], inverse_of: Hydra::PCDM::Vocab::PCDMTerms['hasMember']
  contains "descMetadata", autocreate: false, class_name: 'ActiveFedora::File'
  contains "structMetadata", autocreate: false, class_name: 'ActiveFedora::File'
end