// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/**
 * @title Funciones Especiales: Fallback y Receive
 * @dev Este contrato muestra cómo manejar transacciones que llegan al contrato sin especificar
 *      una función concreta, o transacciones que envían Ether directamente.
 */
contract Fallback_Receive {
    // Evento para registrar qué función fue llamada y con qué datos
    event log(string _name, address _sender, uint _amount, bytes _data);

    /**
     * @notice Función 'fallback'.
     * @dev Se ejecuta en dos casos:
     *      1. Cuando se llama a una función que NO existe en el contrato.
     *      2. Cuando se envía Ether y NO existe la función 'receive' (o 'receive' no puede manejarlo).
     *
     *      Es 'external' (obligatorio) y 'payable' para poder recibir valor si se necesita.
     *      Acepta datos (msg.data), por lo que es útil para patrones como proxies.
     */
    fallback() external payable {
        emit log("fallback", msg.sender, msg.value, msg.data);
    }

    /**
     * @notice Función 'receive'.
     * @dev Se ejecuta EXCLUSIVAMENTE cuando el contrato recibe Ether SIN datos (calldata vacío).
     *      Ejemplo: Una transferencia simple desde una wallet (send/transfer).
     *
     *      Debe ser 'external' y 'payable'. No acepta argumentos ni devuelve nada.
     *      Si no existe 'receive', Solidity intentará usar 'fallback' para recibir Ether.
     */
    receive() external payable {
        emit log("receive", msg.sender, msg.value, "");
    }
}
