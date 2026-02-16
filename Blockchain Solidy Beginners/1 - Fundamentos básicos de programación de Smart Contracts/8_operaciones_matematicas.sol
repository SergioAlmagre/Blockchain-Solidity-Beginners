// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/**
 * @title Operaciones Matemáticas
 * @dev Muestra las operaciones aritméticas básicas en Solidity.
 *      Nota importante: Desde Solidity 0.8.0, las operaciones aritméticas tienen
 *      comprobación automática de desbordamiento (overflow/underflow). Si ocurre,
 *      la transacción revierte automáticamente.
 */
contract maths {
    /**
     * @notice Suma dos números.
     * @dev Si a + b > 2^256 - 1, la transacción revertirá por overflow.
     */
    function suma(uint a, uint b) public pure returns (uint) {
        return a + b;
    }

    /**
     * @notice Resta dos números.
     * @dev Si b > a, la transacción revertirá por underflow (el resultado sería negativo,
     *      que no cabe en un 'uint').
     */
    function resta(uint a, uint b) public pure returns (uint) {
        return a - b;
    }

    /**
     * @notice Multiplicación de dos números.
     */
    function prod(uint a, uint b) public pure returns (uint) {
        return a * b;
    }

    /**
     * @notice División de dos números.
     * @dev Si b es 0, la transacción revierte (división por cero).
     *      Solidity no soporta decimales, el resultado se trunca al entero inferior.
     */
    function div(uint a, uint b) public pure returns (uint) {
        return a / b;
    }

    /**
     * @notice Exponenciación (a elevado a la b).
     */
    function expon(uint a, uint b) public pure returns (uint) {
        return a ** b;
    }

    /**
     * @notice Módulo (Resto de la división).
     * @dev a % b. Útil para verificar si un número es par/impar o múltiplo de otro.
     */
    function mod(uint a, uint b) public pure returns (uint) {
        return a % b;
    }

    // ==========================================
    // Funciones Matemáticas Especiales
    // ==========================================

    /**
     * @notice Suma modular: (x + y) % k.
     * @dev 'addmod' realiza la suma con precisión arbitraria antes de aplicar el módulo.
     *      Esto evita el overflow intermedio si (x + y) supera el máximo uint256.
     *      La segunda parte del retorno muestra el cálculo manual para comparación.
     */
    function _addmod(uint x, uint y, uint k) public pure returns (uint, uint) {
        return (addmod(x, y, k), (x + y) % k);
    }

    /**
     * @notice Multiplicación modular: (x * y) % k.
     * @dev 'mulmod' realiza la multiplicación con precisión arbitraria antes de aplicar el módulo.
     *      Evita overflow si (x * y) es muy grande.
     */
    function _muldod(uint x, uint y, uint k) public pure returns (uint, uint) {
        return (mulmod(x, y, k), (x * y) % k);
    }
}
