// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/**
 * @title Factory Contract (Padre)
 * @dev Este contrato implementa el patrón de diseño "Factory" (Fábrica).
 * Sirve para generar y llevar un registro de otros contratos dependientes (Hijos).
 */
contract padre {
    // Almacenamiento de la información del Factory
    // Mapping para llevar un registro de quién creó qué contrato hijo
    // Clave: Dirección del usuario (msg.sender) => Valor: Dirección del nuevo contrato hijo creado
    mapping(address => address) public personal_contract;

    /**
     * @dev Función para emitir nuevos smart contracts
     * Esta función despliega una nueva instancia del contrato 'hijo'.
     */
    function Factory() public {
        // 'new hijo(...)' crea un nuevo contrato en la blockchain.
        // Se pasan los argumentos requeridos por el constructor del contrato 'hijo'.
        // msg.sender: La dirección de la persona que llama a esta función.
        // address(this): La dirección de este mismo contrato (el contrato fábrica/padre).
        address addr_personal_contract = address(
            new hijo(msg.sender, address(this))
        );

        // Almacenamos la dirección del nuevo contrato en el mapping, vinculado al usuario que lo creó.
        personal_contract[msg.sender] = addr_personal_contract;
    }
}

/**
 * @title Child Contract (Hijo)
 * @dev Este contrato es el producto generado por la fábrica.
 */
contract hijo {
    // Estructura de datos para guardar la información de los propietarios
    struct Owner {
        address _owner; // Dirección del dueño personal
        address _smartcontractPadre; // Dirección del contrato que lo fabricó
    }

    // Variable pública para acceder a los datos del propietario
    Owner public propietario;

    /**
     * @dev Constructor del contrato hijo.
     * Se ejecuta una única vez al ser desplegado por la fábrica.
     * @param _account Dirección del usuario dueño.
     * @param _accountSC Dirección del contrato fábrica (padre).
     */
    constructor(address _account, address _accountSC) {
        // Asignamos los valores recibidos a la estructura de datos
        propietario._owner = _account;
        propietario._smartcontractPadre = _accountSC;
    }
}
