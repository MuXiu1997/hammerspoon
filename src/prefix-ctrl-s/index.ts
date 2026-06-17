/** @noSelfInFile */

import * as cursor from './cursor'
import * as edge from './edge'
import { prefixController } from './modal'

export const moduleName = 'prefix-ctrl-s'
export const log = hs.logger.new(moduleName, 'info')

export function apply(): void {
  log.i(`Initializing [${moduleName}] module...`)
  cursor.apply(prefixController)
  edge.apply(prefixController)
}
