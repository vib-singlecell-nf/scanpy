nextflow.preview.dsl=2

//////////////////////////////////////////////////////
//  process imports:

// scanpy:
include SC__SCANPY__DIM_REDUCTION as SC__SCANPY__DIM_REDUCTION__PCA from '../processes/dim_reduction.nf' params(params + [method: "pca"])
include PCACV__FIND_OPTIMAL_NPCS from './../../pcacv/processes/runPCACV' params(params)

//////////////////////////////////////////////////////

workflow DIM_REDUCTION_PCA {

    take:
        data

    main:
        if(params.pcacv) {
            PCACV__FIND_OPTIMAL_NPCS( data )
            out = SC__SCANPY__DIM_REDUCTION__PCA( data.join(PCACV__FIND_OPTIMAL_NPCS.out.optimalNumberPC) )
        } else {
            data = data.map {
                item -> tuple(item[0], item[1], null)
            }
            out = SC__SCANPY__DIM_REDUCTION__PCA( data )
        }
        
    emit:
        out

}