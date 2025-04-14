using CatalogService as service from './schema';

annotate service.BooksAnalytics with @(
  Aggregation.ApplySupported              : {
    Transformations       : [
      'aggregate',
      'topcount',
      'bottomcount',
      'identity',
      'concat',
      'groupby',
      'filter',
      'search'
    ],
    GroupableProperties  : [ // If we didn't place the columns in the array we get the empty data in the Table
      ID,
      category1,
      category2,
      title,
      stock,
      publishedAt,
      Pages,
      Review
    ],

    // here what we are defining that are we can use in the charts
    AggregatableProperties: [
      {
        $Type   : 'Aggregation.AggregatablePropertyType',
        Property: stock
      },
      {
        $Type   : 'Aggregation.AggregatablePropertyType',
        Property: Pages
      }
    ]
  },
  Aggregation.CustomAggregate #stock      : 'Edm.Decimal', // Defined for column colunt
  Aggregation.CustomAggregate #Pages      : 'Edm.Decimal', // Here we need to define for count
  Common.SemanticKey                      : [ID],


  Analytics.AggregatedProperty #totalStock: {
    $Type               : 'Analytics.AggregatedPropertyType',
    AggregatableProperty: stock,
    AggregationMethod   : 'sum', // By this method we get sum of stock in the chart
    Name                : 'totalStock',
    ![@Common.Label]    : 'Total stock'
  },

) {

  ID    @ID                 : 'ID';
  Pages @Aggregation.default: #AVERAGE; // It Show the average of the column
  stock @Aggregation.default: #SUM; // It shows the column count in the table
}


// Defining the UI.chart
annotate CatalogService.BooksAnalytics with @(UI.Chart: {
  $Type              : 'UI.ChartDefinitionType',
  Title              : 'Stock',
  ChartType          : #Column,
  Dimensions         : [
    category1,
    category2
  ],
  DimensionAttributes: [
    {
      $Type    : 'UI.ChartDimensionAttributeType',
      Dimension: category1,
      Role     : #Category
    },
    {
      $Type    : 'UI.ChartDimensionAttributeType',
      Dimension: category2,
      Role     : #Category2
    }
  ],
  DynamicMeasures    : [ ![@Analytics.AggregatedProperty#totalStock] ],
  MeasureAttributes  : [{
    $Type         : 'UI.ChartMeasureAttributeType',
    DynamicMeasure: ![@Analytics.AggregatedProperty#totalStock],
    Role          : #Axis1
  }]
},

);


annotate CatalogService.BooksAnalytics with @(

UI.PresentationVariant: {
  $Type         : 'UI.PresentationVariantType',
  Visualizations: [
    '@UI.Chart',
    '@UI.LineItem'
  ],
  Total         : [stock],
  GroupBy       : [
    stock,
    title,
    category1
  ]
}

);


// Visual filters
annotate CatalogService.BooksAnalytics with @(
  UI.Chart #category1                  : { // we given in the manifest.json file
    $Type          : 'UI.ChartDefinitionType',
    ChartType      : #Bar,
    Dimensions     : [category1],
    DynamicMeasures: [ ![@Analytics.AggregatedProperty#totalStock] ]
  },
  UI.PresentationVariant #prevCategory1: {
    $Type         : 'UI.PresentationVariantType',
    Visualizations: ['@UI.Chart#category1', ],
  }
) {
  category1 @Common.ValueList #vlCategory1: { // value help is not working so,i defined in the xml file (value list)
    $Type                       : 'Common.ValueListType',
    CollectionPath              : 'BooksAnalytics',
    Parameters                  : [{
      $Type            : 'Common.ValueListParameterInOut',
      ValueListProperty: 'category1',
      LocalDataProperty: 'category1'
    }],
    PresentationVariantQualifier: 'prevCategory1' // with out this chart will does not appear
  }
}


// CATAGORY2
annotate CatalogService.BooksAnalytics with @(
  UI.Chart #category2                  : {
    $Type          : 'UI.ChartDefinitionType',
    ChartType      : #Bar,
    Dimensions     : [category2],
    DynamicMeasures: [ ![@Analytics.AggregatedProperty#totalStock] ]
  },
  UI.PresentationVariant #prevCategory2: {
    $Type         : 'UI.PresentationVariantType',
    Visualizations: ['@UI.Chart#category2', ],
  }
) {
  category2 @Common.ValueList #vlCategory2: {
    $Type                       : 'Common.ValueListType',
    CollectionPath              : 'BooksAnalytics',
    Parameters                  : [{
      $Type            : 'Common.ValueListParameterInOut',
      ValueListProperty: 'category2',
      LocalDataProperty: category2
    }],
    PresentationVariantQualifier: 'prevCategory2'
  }
}

// PublishedAt
annotate CatalogService.BooksAnalytics with @(
  UI.Chart #publishedAt                  : {
    $Type          : 'UI.ChartDefinitionType',
    ChartType      : #Line,
    Dimensions     : [publishedAt],
    DynamicMeasures: [ ![@Analytics.AggregatedProperty#totalStock] ],
    

  },
  UI.PresentationVariant #prevPublishedAt: {
    $Type         : 'UI.PresentationVariantType',
    Visualizations: ['@UI.Chart#publishedAt', ],
  }
) {
  publishedAt @Common.ValueList #vlPublishedAt: {
    $Type                       : 'Common.ValueListType',
    CollectionPath              : 'BooksAnalytics',
    Parameters                  : [{
      $Type            : 'Common.ValueListParameterInOut',
      ValueListProperty: 'publishedAt',
      LocalDataProperty: publishedAt
    }],
    PresentationVariantQualifier: 'prevPublishedAt'
  }
}


//Table
annotate service.BooksAnalytics with @(
  UI.LineItem       : [
    {
      $Type: 'UI.DataField',
      Value: ID
    },
    {
      $Type: 'UI.DataField',
      Value: title
    },
    {
      $Type: 'UI.DataField',
      Value: stock
    },
    {
      $Type: 'UI.DataField',
      Value: category1
    },
    {
      $Type: 'UI.DataField',
      Value: category2
    },
    {
      $Type: 'UI.DataField',
      Value: publishedAt
    },
    {
      $Type: 'UI.DataField',
      Value: Pages
    },
    {
      $Type: 'UI.DataField',
      Value: Review
    }

  ],
  UI.SelectionFields: [
    title,
    stock,
  ],
  
  
);


// Value Lists
annotate service.BooksAnalytics with @() {
  stock @(Common.ValueList: {
    CollectionPath: 'BooksAnalytics', // Entity Name ( entity BooksAnalytics as projection on my.Books;) From schema.cds file
    Parameters    : [{
      $Type            : 'Common.ValueListParameterInOut',
      LocalDataProperty: 'stock', // Column Name
      ValueListProperty: 'stock' // Column Name
    }]
  })
}

annotate service.BooksAnalytics with @() {
  title @(Common.ValueList: {
    CollectionPath: 'BooksAnalytics',
    Parameters    : [{
      $Type            : 'Common.ValueListParameterInOut',
      LocalDataProperty: 'title',
      ValueListProperty: 'title'
    }]
  })
}


// Header at the top of the table for count
annotate service.BooksAnalytics with @UI.HeaderInfo: { //Header Info  Getting the Total count in the table data
  TypeName      : 'Total Records',
  TypeNamePlural: 'Total Records'
};


// Object Page


// Header in the Object Page
annotate CatalogService.BooksAnalytics with @UI.HeaderInfo: {
  Title      : { // Main Title in Header
    $Type: 'UI.DataField',
    Value: title
  },
  Description: { // Description in Header
    $Type: 'UI.DataField',
    Value: category1
  }
};


// Facets in the Object Page
annotate CatalogService.BooksAnalytics with @(UI.Facets: [{
  $Type : 'UI.CollectionFacet',
  Label : 'General Information', // Unique label
  Facets: [
    {
      $Type : 'UI.ReferenceFacet',
      Label : 'Basic Information', // Unique label
      Target: '@UI.FieldGroup#BasicInfo'
    },
    {
      $Type : 'UI.ReferenceFacet',
      Label : 'Stock Details', // Unique label
      Target: '@UI.FieldGroup#StockInfo'
    }
  ]
 },


]);

annotate CatalogService.BooksAnalytics with @(
  UI.FieldGroup #BasicInfo: { // here we are giving the data in the Facets  section-1
    $Type: 'UI.FieldGroupType',
    Label: 'Basic Information',
    Data : [
      {
        $Type: 'UI.DataField',
        Value: ID
      },
      {
        $Type: 'UI.DataField',
        Value: title
      },
      {
        $Type: 'UI.DataField',
        Value: category1
      },
      {
        $Type: 'UI.DataField',
        Value: category2
      }
    ]
  },
  UI.FieldGroup #StockInfo: { // here section-2
    $Type: 'UI.FieldGroupType',
    Label: 'Stock Information',
    Data : [
      {
        $Type: 'UI.DataField',
        Value: stock
      },
      {
        $Type: 'UI.DataField',
        Value: publishedAt
      }
    ]
  }
);
