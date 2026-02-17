// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/**
 * @title Herencia y Funciones Interas
 * @dev Contrato base para demostrar la herencia en Solidity.
 */
contract Food {
    
    // Estructura (Struct) para definir un plato.
    struct dinnerPlate {
        string name;
        string ingredients;
    }

    // Array privado: Solo visible dentro de este contrato.
    // Los contratos hijos NO pueden acceder directamente a variables 'private'.
    // Para que los hijos accedan, debería ser 'internal'.
    dinnerPlate[] private menu;

    /**
     * @notice Añade un nuevo plato al menú.
     * @dev 'internal': Solo visible dentro de este contrato y contratos que heredan de él.
     *      No puede ser llamada desde fuera de la blockchain.
     */
    function newMenu(string memory _name, string memory _ingredients) internal {
        menu.push(dinnerPlate(_name, _ingredients));
    }
}

/**
 * @title Modificadores y Visibilidad
 * @dev 'is Food': Indica que este contrato hereda de 'Food'.
 *      Obtiene acceso a todas las funciones 'internal' y 'public' de Food, pero no a las 'private'.
 */
contract Hamburguer is Food {
    
    address public ouwner; // Nota: 'ouwner' parece ser un typo de 'owner', pero se mantiene por consistencia.

    /**
     * @notice Constructor
     * @dev Se ejecuta al desplegar. Asigna el creador del contrato como 'ouwner'.
     */
    constructor() {
        ouwner = msg.sender;
    }

    /**
     * @notice Cocinar una hamburguesa (añadir al menú).
     * @dev 'external': Solo puede llamarse desde FUERA del contrato (por usuarios u otros contratos).
     *      Suele ser más eficiente en gas que 'public' cuando se reciben grandes arrays de datos.
     * @param _ingredients Ingredientes de la hamburguesa.
     * @param _uints Número de hamburguesas (usado para validación).
     */
    function doHamburguer(string memory _ingredients, uint _uints) external {
        // require: Valida una condición. Si no se cumple, revierte la transacción 
        // y devuelve el mensaje de error, ahorrando el gas restante.
        require(_uints <= 5, "ups, no puedes pedir tantas hamburguesas");
        
        // Llamada a la función interna del contrato padre 'Food'.
        newMenu("Hamburguer", _ingredients);
    }

    // ==========================================
    // Modifiers (Modificadores)
    // ==========================================
    
    /**
     * @dev Modificador personalizado para restringir el acceso.
     *      Se usa para evitar duplicar la lógica de "requerir que sea el dueño".
     */
    modifier onlyOuwner() {
        require(ouwner == msg.sender, "No tienes permisos para ejecutar esta funcion");
        // '_;' indica dónde se insertará el cuerpo de la función original.
        _;
    }

    /**
     * @notice Función restringida al dueño.
     * @dev Usa el modificador 'onlyOuwner'. Si la condición del modificador falla,
     *      esta función no se llega a ejecutar.
     */
    function hashPrivateNumber(uint _number) public view onlyOuwner returns(bytes32) {
        return keccak256(abi.encodePacked(_number));
    }
}