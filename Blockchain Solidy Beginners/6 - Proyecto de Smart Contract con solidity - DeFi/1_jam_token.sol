// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// Direcciones de prueba
// persona 1 (owner) -> 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
// persona 2 (operador) -> 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
// persona 3 (receptor) -> 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db

/**
 * @title JamToken (DeFi Project)
 * @dev Implementación de un contrato ERC-20 desde cero.
 * Escribir el estándar manualmente tiene un gran valor didáctico para entender
 * cómo se mueven realmente los balances y permisos dentro de la blockchain.
 */
contract JamToken {
    // --- Declaraciones y Metadatos ---
    string public name = "JAM Token";
    string public symbol = "JAM";

    // 10**24 equivale a 1,000,000 * 10**18 (1 millón de tokens con 18 decimales)
    uint256 public totalSupply = 10 ** 24;

    // 18 es el estándar en Ethereum para permitir alta divisibilidad (como el gwei en ETH)
    uint8 public decimals = 18;

    // --- Eventos ---
    // Los eventos son CRÍTICOS en el estándar ERC-20. Permiten a las aplicaciones externas
    // (como rastreadores de blockchain o wallets) enterarse de que algo ocurrió sin tener
    // que leer todos los bloques pasados de la red.

    /**
     * @dev Evento para notificar transferencias de tokens.
     * El modificador 'indexed' permite filtrar búsquedas por estas direcciones en el frontend.
     */
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    /**
     * @dev Evento para notificar cuando un propietario autoriza a un operador.
     */
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 value
    );

    // --- Estructuras de Datos ---

    // balanceOf: "Libro mayor" que asocia una dirección (wallet) con su saldo de tokens.
    mapping(address => uint256) public balanceOf;

    // allowance: Diccionario de diccionarios para permisos.
    // ¿Quién? (Dueño) -> ¿A quién le dio permiso? (Operador) -> ¿Cuánto le dejó gastar?
    mapping(address => mapping(address => uint256)) public allowance;

    /**
     * @dev Constructor
     * Se ejecuta solo una vez al desplegar el contrato.
     * Le asignamos TODO el suministro inicial de tokens al creador del contrato (msg.sender).
     */
    constructor() {
        balanceOf[msg.sender] = totalSupply;
    }

    // --- Lógica del Estándar ---

    /**
     * @notice Transfiere tokens del usuario que invoca la función a otra dirección.
     * @param _to Dirección de destino.
     * @param _value Cantidad de tokens a enviar.
     */
    function transfer(address _to, uint256 _value) public returns (bool) {
        // 1. Verificación: Nos aseguramos de que el emisor tenga saldo suficiente.
        require(balanceOf[msg.sender] >= _value, "Balance insuficiente");

        // 2. Ejecución: Restamos al emisor y sumamos al receptor.
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        // 3. Notificación: Emitimos el evento de Transferencia requerido por el estándar.
        emit Transfer(msg.sender, _to, _value);

        return true;
    }

    /**
     * @notice Permite a '_spender' (un operador, ej: un Exchange Descentralizado)
     * gastar hasta '_value' cantidad de tus tokens en un futuro.
     */
    function approve(
        address _spender,
        uint256 _value
    ) public returns (bool success) {
        // Asignamos el permiso en el mapping múltiple.
        allowance[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);

        return true;
    }

    /**
     * @notice Permite a un operador transferir tokens en nombre de un propietario.
     * Requisito: El operador debe haber recibido aprobación previa (`approve`).
     * Ejemplo: Owner aprueba 20 tokens al Operador. Operador mueve 15 tokens al Receptor.
     */
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool) {
        // 1. Verificación del saldo del propietario original.
        require(
            _value <= balanceOf[_from],
            "Saldo insuficiente del propietario"
        );

        // 2. Verificación de que el operador que invoca la funcion (msg.sender) tiene permiso.
        // allowance[_from][msg.sender] -> Permiso que _from le dio a msg.sender
        require(
            _value <= allowance[_from][msg.sender],
            "Permiso insuficiente delegado"
        );

        // 3. Modificación de saldos.
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;

        // 4. Reducción del permiso disponible. (Si gastó 15 de sus 20 permitidos, le quedan 5).
        allowance[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);

        return true;
    }
}
