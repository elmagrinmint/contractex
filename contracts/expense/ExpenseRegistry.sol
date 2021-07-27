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

import '../_library//utility/upgrading/UpgradeableRegistry.sol';

/**
 * @title Registry contract for expense state machines
 */
contract ExpenseRegistry is UpgradeableRegistry {
  constructor(address gatekeeper) UpgradeableRegistry(gatekeeper) {}
}
