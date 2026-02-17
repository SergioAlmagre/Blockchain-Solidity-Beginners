// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/**
 * @title Bucles y Condicionales
 * @dev Muestra el uso de estructuras de control de flujo en Solidity:
 *      - Bucles: for, while
 *      - Condicionales: if, else if, else
 *
 *      Nota de Gas: En Smart Contracts, se debe tener mucho cuidado con los bucles.
 *      Si un bucle itera demasiadas veces, puede consumir todo el gas del bloque
 *      y hacer que la transacción falle. Siempre que sea posible, evita bucles sobre
 *      arrays de tamaño desconocido o muy grande.
 */
contract loops_conditionals {
    /**
     * @notice Suma los 10 números consecutivos a partir del número introducido.
     * @dev Ejemplo de uso de un bucle 'for'.
     *      Estructura: for (inicialización; condición; incremento) { ... }
     * @param _number El número inicial desde el cual empezar la suma.
     * @return El resultado de la suma.
     */
    function sum(uint _number) public pure returns (uint) {
        // Variable auxiliar para almacenar la suma temporal
        uint aux_sum = 0;

        // Bucle for: se ejecutará mientras 'i' sea menor que '_number + 10'
        for (uint i = _number; i < (10 + _number); i++) {
            aux_sum = aux_sum + i;
        }

        return aux_sum;
    }

    /**
     * @notice Suma los primeros 10 números impares.
     * @dev Ejemplo de uso de un bucle 'while' y condicional 'if'.
     *      Usa el operador módulo (%) para determinar si un número es impar.
     * @return La suma de los primeros 10 números impares (1+3+5...+19 = 100).
     */
    function odd() public pure returns (uint) {
        uint aux_sum = 0;
        uint counter = 0;
        uint counter_odd = 0;

        // Bucle while: se ejecuta mientras la condición sea verdadera
        while (counter_odd < 10) {
            // Condicional if: Comprueba si el número es impar
            // Par   -> a % 2 = 0
            // Impar -> a % 2 != 0
            if (counter % 2 != 0) {
                aux_sum = aux_sum + counter;
                counter_odd++; // Incrementamos el contador de impares encontrados
            }

            counter++; // Incrementamos el contador general en cada iteración
        }

        return aux_sum;
    }

    /**
     * @notice Realiza una operación ("suma" o "resta") basada en un string.
     * @dev En Solidity, NO se pueden comparar strings directamente con '=='.
     *      Para compararlos, primero debemos calcular su hash (keccak256) y comparar los hashes.
     * @param operation El nombre de la operación: "suma" o "resta".
     * @param a Primer operando.
     * @param b Segundo operando.
     * @return El resultado de la operación, o 99999999 si la operación no es válida.
     */
    function sum_rest(
        string memory operation,
        uint a,
        uint b
    ) public pure returns (uint) {
        // Calculamos el hash del string de entrada
        bytes32 hash_operation = keccak256(abi.encodePacked(operation));

        // Comparamos con el hash de "suma"
        if (hash_operation == keccak256(abi.encodePacked("suma"))) {
            return a + b;
        }
        // Comparamos con el hash de "resta"
        else if (hash_operation == keccak256(abi.encodePacked("resta"))) {
            return a - b;
        }
        // Caso por defecto (operación no reconocida)
        else {
            return 99999999;
        }
    }
}
