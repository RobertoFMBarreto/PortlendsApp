const db_config = require('../DB_config');
const sql = require('mssql')
const queries = require('../events/queries')

let get_search_produtos_categoria = async (req,res)=>{
    let idParam = req.params.id
    let{pesquisa}=req.body
    try {
        pesquisa = pesquisa + '%'
        
        let pool = await sql.connect(db_config)
        
        let result = await pool.request()
            .input('idParam', idParam)
            .input('name', pesquisa)
            .query(queries.getSearchCategoryProd)
          
        pool.close()
        
        
        res.status(200).json({
            "message": "Selected products",
            "result": result.recordset
            })

    } catch (err) {
        
        res.status(500).send(err)
    }
}

let get_produtos_categoria = async (req,res)=>{
    let idParam = req.params.id
    try {
        
        let pool = await sql.connect(db_config)
        
        let result = await pool.request()
            .input('idParam', idParam)
            .query(queries.getAllCategoryProd)
          
        pool.close()
        
        res.status(200).json({
            "message": "Selected products",
            "result": result.recordset
            })

    } catch (err) {
        
        res.status(500).send(err)
    }
}

let get_produto = async (req,res)=>{
    let idParam = req.params.id
    try {
        
        let pool = await sql.connect(db_config)
        
        let result = await pool.request()
            .input('pdID', idParam)
            .query(queries.getProduct)
          
        pool.close()
        res.status(200).json({
            "message": "Selected product",
            "result": result.recordset[0]
            })

    } catch (err) {
        
        res.status(500).send(err)
    }
}

let delete_produto = async (req,res)=>{
    let idParam = req.params.id
    try {
        
        let pool = await sql.connect(db_config)
        
        let result = await pool.request()
            .input('pdID', idParam)
            .query(queries.deleteProduct)
          
        pool.close()
        res.status(200).json({
            "message": "Produto eliminado",
            })

    } catch (err) {
        
        res.status(500).send(err)
    }
}


let get_produtos_categoria_subcategoria = async (req,res)=>{
    let {categoriaID, subcategoriaID} = req.body
    try {
 
        let pool = await sql.connect(db_config)


        let result = await pool.request()
            .input("categoriaId", sql.Int, categoriaID)
            .input("subcategoriaId", sql.Int, subcategoriaID)
            .query(queries.getAllCategorySubcategoryProd)
        
      
        pool.close()


        res.status(200).json({
            "message": "Selected Products",
            "result": result.recordset
            })

    } catch (err) {
        
        res.status(500).send(err)
    }
}

let get_search_produtos_categoria_subcategoria = async (req,res)=>{
    let {categoriaID, subcategoriaID,pesquisa} = req.body
    try {
 
        let pool = await sql.connect(db_config)

        pesquisa =  pesquisa + '%'
        let result = await pool.request()
            .input("categoriaId",  categoriaID)
            .input("subcategoriaId",  subcategoriaID)
            .input("name", pesquisa)
            .query(queries.getSearchCategorySubcategoryProd)
        
      
        pool.close()


        res.status(200).json({
            "message": "Selected Products",
            "result": result.recordset
            })

    } catch (err) {
        
        res.status(500).send(err)
    }
}

module.exports={
    get_produtos_categoria,
    get_produtos_categoria_subcategoria,
    get_produto,
    delete_produto,
    get_search_produtos_categoria,
    get_search_produtos_categoria_subcategoria
}