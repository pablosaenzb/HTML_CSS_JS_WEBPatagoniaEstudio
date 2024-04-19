import React from "react"

import styles from "./Inserter.module.css"
import stylesShared from "../shared.module.css"
import stylesImporter from "./Importer.module.css"
import { api } from "../util/api"
import { config } from "../util/config"

export default class Inserter extends React.PureComponent {
  constructor(props) {
    super(props)
    this.state = {
      inserting: false,
    }
  }

  doInsert = () => {
    const { importData, photoUploadCompleteCallback, category, item } = this.props
    this.setState({ inserting: true })

    api
      .post(`insert/${category}/process`, importData, { retryCallbac: this.doImport })
      .then(
        (json) => {
          if (photoUploadCompleteCallback) {
            photoUploadCompleteCallback(item, json)
          } else {
            // We're in modal land, hide the modal and insert template calling Elementor API
            if (typeof elementor !== "undefined") {

              let insertIndex = config.get("insertIndex")
              if(typeof $e !== 'undefined') {
                const historyId = $e.internal('document/history/start-log', {
                  type: 'add',
                  title: 'Add Envato Elements Block'
                });
                for (let i = 0; i < json.data.content.length; i++) {
                  $e.run( 'document/elements/create', {
                    container: elementor.getPreviewContainer(),
                    model: json.data.content[ i ],
                    options: insertIndex >= 0 ? { at: insertIndex++ } : {}
                  } )
                }
                $e.internal('document/history/end-log', {
                  id: historyId
                });
              }else {
                const model = new Backbone.Model({
                  getTitle() {
                    return "Test"
                  },
                })
                elementor.channels.data.trigger( "template:before:insert", model )
                let insertIndex = config.get( "insertIndex" )
                for ( let i = 0; i < json.data.content.length; i++ ) {
                  elementor
                    .getPreviewView()
                    .addChildElement( json.data.content[ i ], insertIndex >= 0 ? { at: insertIndex++ } : null )
                }
                elementor.channels.data.trigger( "template:after:insert", {} )
              }
            }
          }
          window.elementsModal && window.elementsModal.hide()
        },
        (err) => {},
      )
      .finally(() => {
        this.setState({ inserting: false })
      })
  }

  render() {
    const { label, item } = this.props
    const { inserting } = this.state
    return (
      <div className={styles.wrap}>
        <button
          type="button"
          onClick={this.doInsert}
          disabled={inserting}
          className={`${stylesShared.button} ${stylesImporter.animatedButton} ${
            inserting ? stylesImporter.importing : ""
          }`}>
          {inserting ? "Inserting..." : label || "Insert"}
          <span />
        </button>
      </div>
    )
  }
}

Inserter.propTypes = {}
