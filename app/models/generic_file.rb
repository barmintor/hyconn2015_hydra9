require 'hydra/pcdm/vocab/pcdm_terms'
class GenericFile < ActiveFedora::Base
  has_and_belongs_to_many :collectors, class_name: 'ActiveFedora::Base',
    predicate: Hydra::PCDM::Vocab::PCDMTerms['memberOf'], inverse_of: Hydra::PCDM::Vocab::PCDMTerms['hasMember']
  contains "content", autocreate: false, class_name: 'ActiveFedora::File'
end