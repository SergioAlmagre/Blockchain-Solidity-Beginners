// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.4;

/**
 * @title Estructuras de Datos en Solidity
 * @dev Muestra el uso de structs, arrays (fijos y dinámicos) y mappings.
 *      Estos son los bloques de construcción fundamentales para almacenar datos complejos.
 */
contract data_structures {
    
    // ==========================================
    // Structs (Estructuras personalizadas)
    // ==========================================
    
    /** 
     * @dev Struct para definir un 'Customer' (Cliente).
     * Permite agrupar múltiples variables de tipos diferentes bajo un mismo nombre.
     */
    struct Customer{
        uint256 id;
        string name;
        string email;
    }

    // Variable de estado tipo Customer iniciada por defecto.
    Customer customer_1 = Customer(1, "Sergio", "sergio@gmail.com");
    
    // ==========================================
    // Arrays (Listas)
    // ==========================================
    
    // Array de longitud fija: Su tamaño (5) no puede cambiar.
    // Solo puede contener elementos del tipo uint256.
    uint256[5] public fixed_list_uints = [1,2,3,4,5];

    // Array de longitud dinámica de direcciones (address).
    // Su tamaño puede crecer o disminuir.
    address[] public dynamic_list_uints; 
    
    // Array dinámico de estructuras Customer.
    Customer[] public dynamic_list_customers;

    /**
     * @notice Añade un nuevo cliente al array dinámico.
     * @dev Crea una nueva instancia de Customer en memoria y la empuja al array.
     * @param _id Identificador del cliente.
     * @param _name Nombre del cliente.
     * @param _email Email del cliente.
     */
    function array_modification (uint256 _id, string memory _name, string memory _email) public {
        Customer memory random_customer = Customer(_id, _name, _email);
        dynamic_list_customers.push(random_customer);
    }

    // ==========================================
    // Mappings (Diccionarios / Hash Maps)
    // ==========================================
    // Los mappings son estructuras clave-valor. No tienen longitud ni se pueden iterar nativamente.
    
    // Mapping simple: Dirección -> Número
    mapping (address => uint256) public address_uint;
    
    // Mapping complejo: String -> Array de números
    mapping (string => uint256 []) public string_listUnits;
    
    // Mapping de Dirección -> Struct Customer
    mapping (address => Customer) public address_dataStructure;

    /**
     * @notice Asigna un número a la dirección del remitente (msg.sender).
     * @param _number El número a asignar.
     */
    function assingNumber (uint256 _number) public {
        address_uint[msg.sender] = _number;
    }

    /**
     * @notice Añade un número a la lista asociada a un nombre.
     * @param _name La clave del mapping (string).
     * @param _number El valor a añadir al array.
     */
    function assingList (string memory _name, uint256 _number) public {
        string_listUnits[_name].push(_number);
    }

    /**
     * @notice Asigna una estructura Customer completa a la dirección del remitente.
     * @dev Crea la estructura al vuelo con los parámetros proporcionados.
     */
    function assingDataStructure (uint256 _id, string memory _name, string memory _email) public {
        address_dataStructure[msg.sender] = Customer(_id, _name, _email);
    }

    /**
     * @notice Asigna una estructura Customer pasada como parámetro a la dirección del remitente.
     */
    function assignDataStructure_2 (Customer memory cus) public{
        address_dataStructure[msg.sender] = cus;
    }

}