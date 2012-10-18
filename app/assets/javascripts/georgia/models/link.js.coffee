class Georgia.Models.Link extends Backbone.RelationalModel
  urlRoot: '/api/links'

  relations: [
    type: Backbone.HasMany
    key: 'contents'
    relatedModel: 'Georgia.Models.Content'
    collectionType: 'Georgia.Collections.Contents'
    includeInJSON: false
    reverseRelation:
      key: 'link'
      includeInJSON: false
  ]

  toJSON: ->
    link:
      menu_id: this.attributes.menu_id
      page_id: this.attributes.page_id
      dropdown: this.attributes.dropdown
      contents_attributes: this.get('contents').toJSON()

Georgia.Models.Link.setup()