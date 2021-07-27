/**
 * Copyright (C) SettleMint NV - All Rights Reserved
 *
 * Use of this file is strictly prohibited without an active license agreement.
 * Distribution of this file, via any medium, is strictly prohibited.
 *
 * For license inquiries, contact hello@settlemint.com
 *
 * SPDX-License-Identifier: UNLICENSED
 */

pragma solidity ^0.8.0;

import '../_library//authentication/RoleRegistry.sol';

/**
 * @title Lists all customers
 */
contract CustomerRoleRegistry is RoleRegistry {
  bytes32 public constant ROLE_CUSTOMER = 'ROLE_CUSTOMER';

  constructor(address gatekeeper) RoleRegistry(gatekeeper) {}

  /**
   * @dev Returns the role
   * @return A bytes32 role
   */
  function role() public pure returns (bytes32) {
    return ROLE_CUSTOMER;
  }
}
