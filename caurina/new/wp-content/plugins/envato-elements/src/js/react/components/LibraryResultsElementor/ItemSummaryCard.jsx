import { LazyLoadComponent, trackWindowScroll } from "react-lazy-load-image-component"
import { Link } from "react-router-dom"
import React from "react"
import PropTypes from "prop-types"
import styles from "./LibraryResultsElementor.module.css"
import ImportTemplate from "./ImportTemplate"
import PreviewImage from "./PreviewImage"
import ItemFeatures from "./ItemFeatures"
import MissingPlugins from "./MissingPlugins"
import FeatureOverlay from "./FeatureOverlay"
import PremiumNotice from "./PremiumNotice"
import { config } from "../../util/config"

const ItemResults = ({
  fromSearch,
  result,
  scrollPosition,
  getModalPos,
  updateSingleItem,
  searchChanges,
  ignorePluginWarnings,
  setIgnorePluginWarnings,
}) => {
  const isPremiumKit = result.features && !!result.features.premium
  const showPremiumRequiredNotice = isPremiumKit && config.get("elements_status") !== "paid"
  let allowTemplateImport = !isPremiumKit || (isPremiumKit && config.get("elements_status") === "paid")

  return (
    <LazyLoadComponent scrollPosition={scrollPosition} placeholder={<div className={styles.squareWrapLoading} />}>
      <div
        className={`${styles.squareWrap} ${styles.squareSummary}`}>
        <div className={styles.inner}>
          <div className={styles.background} style={{ backgroundImage: `url( ${result.collectionThumbnail} )` }} />
          <div className={styles.features}>
            <FeatureOverlay result={result} template={{}} />
          </div>
          <Link
            to={`/${result.categorySlug}?collectionId=${result.collectionId}`}
            onClick={(e) => {
              e.preventDefault()
              searchChanges({ collectionId: result.collectionId, templateId: null })
              return false
            }}
            className={styles.thumb}>
            &nbsp;
          </Link>
        </div>
        <div className={styles.details}>
          <div className={styles.detailsItemName}>
            <h3 className={styles.detailsItemNameTitle}>{result.collectionName}</h3>
          </div>
        </div>
      </div>
    </LazyLoadComponent>
  )
}

ItemResults.propTypes = {
  fromSearch: PropTypes.bool,
  scrollPosition: PropTypes.shape({
    x: PropTypes.number,
    y: PropTypes.number,
  }),
  openItem: PropTypes.shape({}),
  getModalPos: PropTypes.shape({
    pos: PropTypes.string,
  }).isRequired,
  updateSingleItem: PropTypes.func.isRequired,
  searchChanges: PropTypes.func.isRequired,
  ignorePluginWarnings: PropTypes.bool,
  setIgnorePluginWarnings: PropTypes.func,
  result: PropTypes.shape({
    categorySlug: PropTypes.string,
    collectionName: PropTypes.string,
    features: PropTypes.shape({
      premium: PropTypes.string,
      new: PropTypes.string,
    }),
    collectionId: PropTypes.string,
    templates: PropTypes.arrayOf(
      PropTypes.shape({
        templateId: PropTypes.string,
      }),
    ),
  }).isRequired,
  template: PropTypes.shape( {
    templateId: PropTypes.string,
    templateName: PropTypes.string,
    itemImported: PropTypes.bool,
    largeThumb: PropTypes.string.isRequired
  })
}

ItemResults.defaultProps = {
  fromSearch: false,
  openItem: null,
  ignorePluginWarnings: false,
  setIgnorePluginWarnings: null,
  scrollPosition: {},
}

export default trackWindowScroll(ItemResults)
